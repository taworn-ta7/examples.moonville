'use strict';
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const entities = require('../entities');
const validators = require('../validators');
const { dump, authen } = require('../middlewares');

/**
 * Change settings.
 */
router.put('/', [
	authen.required,
	dump.body,
	validate({
		body: Joi.object({
			user: Joi.object({
				locale: validators.AccountUsers.locale,
				theme: validators.AccountUsers.theme,
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const json = req.body.user;

	// update
	if (!(typeof json.locale in [null, undefined]))
		req.user.locale = json.locale;
	if (!(typeof json.theme in [null, undefined]))
		req.user.theme = json.theme;
	await req.user.update({
		locale: req.user.locale,
		theme: req.user.theme,
	});

	// insert log
	await entities.Loggings.create({
		userId: req.user.id,
		action: 'update',
		table: 'AccountUsers',
		description: `User ${req.user.id} settings changed.`,
	});

	// success
	res.ret = {
		user: await entities.AccountUsers.findByPk(req.user.id),
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
