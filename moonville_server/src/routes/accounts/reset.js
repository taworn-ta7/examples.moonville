'use strict';
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const { RestError, errors, mail } = require('../../libs');
const entities = require('../../entities');
const validators = require('../../validators');
const { setPassword, generateToken } = require('../../utils/authen');
const { dump } = require('../../middlewares');



// ----------------------------------------------------------------------
// Reset Password
// ----------------------------------------------------------------------

/**
 * Request reset password.
 */
router.post('/request-reset', [
	dump.body,
	validate({
		body: Joi.object({
			user: Joi.object({
				email: validators.AccountUsers.email.required(),
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const json = req.body.user;

	// check email already exists or not
	const user = await entities.AccountUsers.findOne({ where: { email: json.email } });
	if (!user)
		throw new RestError(errors.notFound, { context: 'user' });

	// insert reset
	const reset = await entities.AccountResets.create({
		email: json.email,
		confirmToken: generateToken(),
	});

	// send mail
	const uri = `${req.protocol}://${req.get('host')}${req.baseUrl}/reset?code=${reset.confirmToken}`;
	mail.send({
		from: process.env.MAIL_ADMIN,
		to: reset.email,
		subject: "Reset password email",
		text: `You reset password code is ${reset.confirmToken}.\nCopy this link and paste to browser:\n${uri}`,
		html: `You reset password code is <a href="${uri}">${reset.confirmToken}</a>.`,
	});

	// success
	res.ret = {
		reset,
		uri,
	};
	res.status(StatusCodes.CREATED).send(res.ret);
	next();
}));

/**
 * Reset password.
 */
router.get('/reset', [
	dump.body,
], asyncHandler(async (req, res, next) => {
	// get request
	const { code } = req.query;

	// load reset data from code
	if (!code)
		throw new RestError(errors.notFound, { context: 'user' });
	const reset = await entities.AccountResets.findOne({ where: { confirmToken: code } });
	if (!reset)
		throw new RestError(errors.notFound, { context: 'user' });

	// check email already exists or not
	const user = await entities.AccountUsers.findOne({
		where: { email: reset.email },
		include: entities.AccountTokens,
	});
	if (!user)
		throw new RestError(errors.notFound, { context: 'user' });

	// update new password
	const generate = generateToken().substring(0, 8);
	const password = setPassword(generate);
	await user.accountToken.update({
		salt: password.salt,
		hash: password.hash,
		token: null,
	});

	// insert log
	await entities.Loggings.create({
		userId: user.id,
		action: 'update',
		table: 'AccountTokens',
		description: `User ${user.id} is reset password.`,
	});

	// send mail
	mail.send({
		from: process.env.MAIL_ADMIN,
		to: reset.email,
		subject: "You have reset your password",
		text: `Your new password is ${generate}.`,
		html: `Your new password is ${generate}.`,
	});

	// success
	res.ret = {
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
