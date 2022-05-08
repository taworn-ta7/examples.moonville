'use strict';
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const { RestError, errors, db } = require('../libs');
const entities = require('../entities');
const validators = require('../validators');
const { validatePassword, newOrUpdateToken } = require('../utils/authen');
const { dump, authen } = require('../middlewares');

/**
 * Login into the system.
 */
router.put('/login', [
	dump.body,
	validate({
		body: Joi.object({
			login: Joi.object({
				email: validators.AccountUsers.email.required(),
				password: validators.AccountUsers.password.required(),
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const json = req.body.login;

	// select user
	const user = await entities.AccountUsers.findOne({
		where: { email: json.email },
		include: entities.AccountTokens,
	});
	if (!user || !validatePassword(json.password, user.accountToken.salt, user.accountToken.hash))
		throw new RestError(errors.invalidEmailPassword);

	// check if user disabled or unregistered
	if (user.resigned)
		throw new RestError(errors.userIsResigned);
	if (user.disabled)
		throw new RestError(errors.userIsDisabledByAdmin);

	// check if expiry login
	const token = await newOrUpdateToken(user);

	// insert log
	await entities.Loggings.create({
		userId: user.id,
		action: 'update',
		table: 'AccountUsers',
		description: `User ${user.id} is login.`,
	});

	// success
	res.ret = {
		user: await entities.AccountUsers.findByPk(user.id),
		token,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

/**
 * Logout from the system.
 */
router.put('/logout', [
	authen.required,
], asyncHandler(async (req, res, next) => {
	// save id
	const id = req.user.id;

	// update
	await db.transaction(async (t) => {
		await req.user.update({
			end: new Date(),
		}, { transaction: t });
		await req.user.accountToken.update({
			token: null,
		}, { transaction: t });
	});
	req.user = undefined;

	// insert log
	await entities.Loggings.create({
		userId: id,
		action: 'update',
		table: 'AccountUsers',
		description: `User ${id} is logout.`,
	});

	// success
	res.ret = {
		user: await entities.AccountUsers.findByPk(id),
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

/**
 * Check login status and renew expiry token.
 */
router.get('/check', [
	authen.required,
], asyncHandler(async (req, res, next) => {
	// success
	res.ret = {
		user: await entities.AccountUsers.findByPk(req.user.id),
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
