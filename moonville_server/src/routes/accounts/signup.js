'use strict';
const { ulid } = require('ulid');
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const { RestError, errors, db, mail } = require('../../libs');
const entities = require('../../entities');
const validators = require('../../validators');
const { setPassword, generateToken } = require('../../utils/authen');
const { dump } = require('../../middlewares');



// ----------------------------------------------------------------------
// Sign Up
// ----------------------------------------------------------------------

/**
 * Register new signup user.
 */
router.post('/signup', [
	dump.body,
	validate({
		body: Joi.object({
			user: Joi.object({
				email: validators.AccountUsers.email.required(),
				password: validators.AccountUsers.password.required(),
				confirmPassword: Joi.any().valid(Joi.ref('password')).required(),
				locale: validators.AccountUsers.locale.required(),
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const json = req.body.user;

	// check email already exists or not
	if (await entities.AccountUsers.findOne({ where: { email: json.email } }))
		throw new RestError(errors.alreadyExists, { context: 'user' });

	// insert signup
	const password = setPassword(json.password);
	const signup = await entities.AccountSignups.create({
		email: json.email,
		locale: json.locale,
		salt: password.salt,
		hash: password.hash,
		confirmToken: generateToken(),
	});

	// send mail
	const uri = `${req.protocol}://${req.get('host')}${req.baseUrl}/confirm?code=${signup.confirmToken}`;
	mail.send({
		from: process.env.MAIL_ADMIN,
		to: signup.email,
		subject: "Signup confirmation email",
		text: `You signup code is ${signup.confirmToken}.\nCopy this link and paste to browser:\n${uri}`,
		html: `You signup code is <a href="${uri}">${signup.confirmToken}</a>.`,
	});

	// success
	res.ret = {
		signup,
		uri,
	};
	res.status(StatusCodes.CREATED).send(res.ret);
	next();
}));

/**
 * Confirm the signup.
 */
router.get('/confirm', [
	dump.body,
], asyncHandler(async (req, res, next) => {
	// get request
	const { code } = req.query;

	// load signup user from code
	if (!code)
		throw new RestError(errors.notFound, { context: 'user' });
	const signup = await entities.AccountSignups.findOne({ where: { confirmToken: code } });
	if (!signup)
		throw new RestError(errors.notFound, { context: 'user' });

	// check email already exists or not
	if (await entities.AccountUsers.findOne({ where: { email: signup.email } }))
		throw new RestError(errors.alreadyExists, { context: 'user' });

	// insert user
	const id = ulid();
	const names = signup.email.split("@");
	const name = names[0].charAt(0).toUpperCase() + names[0].slice(1);
	let user;
	await db.transaction(async (t) => {
		user = await entities.AccountUsers.create({
			id,
			email: signup.email,
			name,
			locale: signup.locale,
			role: 'user',
		}, { transaction: t });
		await entities.AccountTokens.create({
			id,
			salt: signup.salt,
			hash: signup.hash,
		}, { transaction: t });
	});

	// insert log
	await entities.Loggings.create({
		userId: id,
		action: 'create',
		table: 'AccountUsers',
		description: `User ${id} is signup and confirm.`,
	});

	// success
	res.ret = {
		user,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
