'use strict';
const path = require('path');
const fs = require('fs');
const mime = require('mime-types');
const { Op } = require('sequelize');
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { Joi, validate } = require('express-validation');
const { RestError, errors } = require('../../libs');
const entities = require('../../entities');
const validators = require('../../validators');
const { authen } = require('../../middlewares');
const { getPaginate, queryGenericData } = require('../../utils/page-utils');



// ----------------------------------------------------------------------
// View
// ----------------------------------------------------------------------

/**
 * Get account user list.
 */
router.get('/', [
	authen.optional,
	validate({
		query: Joi.object({
			page: validators.Generic.page,
			order: validators.Generic.order,
			search: validators.Generic.search,
			trash: validators.Generic.trash,
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const { page, order, search, trash } = queryGenericData(req, {
		email: 'email',
		name: 'name',
		createdAt: 'createdAt',
		created_at: 'createdAt',
	});

	// conditions
	let searchConditions = null;
	if (search && search.length > 0) {
		searchConditions = {
			[Op.or]: [
				{ email: { [Op.like]: `${search}%` } },
				{ name: { [Op.like]: `${search}%` } },
			],
		};
	}
	let trashConditions = null;
	if (trash && trash !== 0) {
		trashConditions = {
			[Op.or]: [
				{ disabled: { [Op.not]: null } },
				{ resigned: { [Op.not]: null } },
			],
		};
	}
	else {
		trashConditions = {
			[Op.and]: [
				{ disabled: null },
				{ resigned: null },
			],
		};
	}
	let conditions = [];
	if (searchConditions)
		conditions.push(searchConditions);
	if (trashConditions)
		conditions.push(trashConditions);
	const where = {
		[Op.and]: conditions,
		role: {
			[Op.not]: 'admin',
		},
	};

	// select
	const rowsPerPage = +process.env.ROWS_PER_PAGE_10;
	const query = {
		where,
		order,
		offset: page * rowsPerPage,
		limit: rowsPerPage,
	};
	const count = await entities.AccountUsers.count(query);
	const users = await entities.AccountUsers.findAll(query);

	// success
	res.ret = {
		paginate: getPaginate(page, rowsPerPage, count),
		users,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

/**
 * Get account user.
 */
router.get('/:email', [
	authen.optional,
	validate({
		params: Joi.object({
			email: validators.AccountUsers.email.required(),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const { email } = req.params;

	// select
	const user = await entities.AccountUsers.findOne({ where: { email } });
	if (!user)
		throw new RestError(errors.notFound, { context: 'user' });

	// success
	res.ret = {
		user,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

/**
 * View account user's icon.
 */
router.get('/icon/:email', [
	authen.optional,
], asyncHandler(async (req, res, next) => {
	// get request
	const { email } = req.params;

	// select
	const user = await entities.AccountUsers.findOne({ where: { email } });
	if (!user)
		throw new RestError(errors.notFound, { context: 'user' });

	// view icon file
	const dir = path.join(process.env.STORAGE_PATH, user.id, 'profile');
	const iconFile = path.join(dir, `icon`);
	const mimeFile = path.join(dir, `icon-mime`);
	let data;
	let contentType;
	try {
		await fs.promises.access(iconFile);
		data = await fs.promises.readFile(iconFile);
		contentType = await fs.promises.readFile(mimeFile);
	}
	catch (ex) {
		const defaultFile = path.resolve(path.join(__dirname, '../..', 'assets', 'default-profile-icon.png'));
		data = await fs.promises.readFile(defaultFile);
		contentType = mime.contentType(defaultFile);
	}

	// output
	res.writeHead(StatusCodes.OK, { 'Content-Type': contentType });
	res.end(data);
}));



// ----------------------------------------------------------------------
// Edit
// ----------------------------------------------------------------------

/**
 * Disable/enable account user.
 */
router.put('/disable/:email', [
	authen.adminRequired,
	validate({
		params: Joi.object({
			email: validators.AccountUsers.email.required(),
		}),
		body: Joi.object({
			user: Joi.object({
				disabled: validators.AccountUsers.disabled.required(),
			}),
		}),
	}),
], asyncHandler(async (req, res, next) => {
	// get request
	const { email } = req.params;
	const json = req.body.user;

	// select
	const user = await entities.AccountUsers.findOne({
		where: {
			email,
			role: 'user',
		},
	});
	if (!user)
		throw new RestError(errors.notFound, { context: 'user' });

	// update
	const now = new Date();
	await user.update({
		disabled: json.disabled ? now : null,
		end: null,
		token: null,
	});

	// insert log
	await entities.Loggings.create({
		userId: req.user.id,
		action: 'update',
		table: 'AccountUsers',
		description: `User ${req.user.id} changed ${user.id}, disabled = ${json.disabled}.`,
	});

	// success
	res.ret = {
		user,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
