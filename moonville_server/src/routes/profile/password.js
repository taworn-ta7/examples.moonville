'use strict';
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const { db } = require('../../libs');
const entities = require('../../entities');
const validators = require('../../validators');
const { setPassword } = require('../../utils/authen');
const { dump, authen } = require('../../middlewares');

/**
 * Change the current user's password.
 */
router.put('/password', [
	authen.required,
	dump.body,
	validate({
		body: Joi.object({
			user: Joi.object({
				password: validators.AccountUsers.password.required(),
				confirmPassword: Joi.any().valid(Joi.ref('password')).required(),
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const json = req.body.user;

	// save id
	const id = req.user.id;

	// update
	const password = setPassword(json.password);
	await db.transaction(async (t) => {
		await req.user.update({
			end: new Date(),
		}, { transaction: t });
		await req.user.accountToken.update({
			salt: password.salt,
			hash: password.hash,
			token: null,
		}, { transaction: t });
	});
	req.user = undefined;

	// insert log
	await entities.Loggings.create({
		userId: id,
		action: 'update',
		table: 'AccountUsers',
		description: `User ${id} changed password!`,
	});

	// success
	res.ret = {
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
