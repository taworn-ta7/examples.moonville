'use strict';
const { StatusCodes } = require('http-status-codes');
const errors = {
	timeout: {
		status: StatusCodes.UNAUTHORIZED,
		message: "timeout",
	},
	invalidToken: {
		status: StatusCodes.UNAUTHORIZED,
		message: "invalid token",
	},
	requirePermission: {
		status: StatusCodes.FORBIDDEN,
		message: "require permission",
	},
	invalidEmailPassword: {
		status: StatusCodes.UNPROCESSABLE_ENTITY,
		message: "invalid email/password",
	},
	userIsDisabledByAdmin: {
		status: StatusCodes.UNPROCESSABLE_ENTITY,
		message: "user is disabled by admin",
	},
	userIsResigned: {
		status: StatusCodes.UNPROCESSABLE_ENTITY,
		message: "user is resigned",
	},
	notJson: {
		status: StatusCodes.INTERNAL_SERVER_ERROR,
		message: "not JSON",
	},
	notFound: {
		status: StatusCodes.NOT_FOUND,
		message: "not found",
	},
	deleted: {
		status: StatusCodes.NOT_FOUND,
		message: "deleted",
	},
	alreadyExists: {
		status: StatusCodes.FORBIDDEN,
		message: "already exists",
	},
	duplicate: {
		status: StatusCodes.FORBIDDEN,
		message: "duplicate",
	},
	noUploadFile: {
		status: StatusCodes.BAD_REQUEST,
		message: "no upload file",
	},
	uploadFileIsNotType: {
		status: StatusCodes.BAD_REQUEST,
		message: "upload file is not type",
	},
	uploadFileIsTooLarge: {
		status: StatusCodes.BAD_REQUEST,
		message: "upload file is too large",
	},
	invalidSignInExternal: {
		status: StatusCodes.UNPROCESSABLE_ENTITY,
		message: "invalid signin external",
	},
	validationFailed: {
		status: StatusCodes.BAD_REQUEST,
		message: "validation failed",
	},
}
module.exports = errors;
