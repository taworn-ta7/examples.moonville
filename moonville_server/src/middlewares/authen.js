'use strict';
const asyncHandler = require('express-async-handler');
const { RestError, errors } = require('../libs');
const { userFromHeaders } = require('../utils/authen');

/**
 * Optionally load user.
 */
const optional = asyncHandler(async (req, res, next) => {
	try {
		req.user = await userFromHeaders(req);
	}
	catch (ex) {
		req.user = null;
	}
	next();
});

/**
 * Required load user.
 */
const required = asyncHandler(async (req, res, next) => {
	req.user = await userFromHeaders(req);
	next();
});

/**
 * User-only required load user.
 */
const userRequired = asyncHandler(async (req, res, next) => {
	const user = await userFromHeaders(req);
	if (user.role !== 'user')
		throw new RestError(errors.requirePermission, { context: 'user' });
	req.user = user;
	next();
});

/**
 * Admin-only required load user.
 */
const adminRequired = asyncHandler(async (req, res, next) => {
	const user = await userFromHeaders(req);
	if (user.role !== 'admin')
		throw new RestError(errors.requirePermission, { context: 'admin' });
	req.user = user;
	next();
});

module.exports = {
	optional,
	required,
	userRequired,
	adminRequired,
};
