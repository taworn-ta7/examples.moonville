'use strict';
const logger = require('../libs/logger');

/**
 * Dump request's headers to log.
 */
const headers = (req, res, next) => {
	logger.verbose(`${req.id} request headers: ${debugFormat(req.headers)}`);
	next();
};

/**
 * Dump request's body to log.
 */
const body = (req, res, next) => {
	logger.verbose(`${req.id} request body: ${debugFormat(req.body)}`);
	next();
};

module.exports = {
	headers,
	body,
};
