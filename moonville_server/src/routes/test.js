'use strict';
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');



// ----------------------------------------------------------------------
// Testing
// ----------------------------------------------------------------------

/**
 * Test route.
 */
router.get('/test', [
], asyncHandler(async (req, res, next) => {
	// success
	res.ret = {
		'ok': true
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
