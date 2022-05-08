'use strict';
const i18next = require('i18next');
const cors = require('cors');
const { ulid } = require('ulid');
const { StatusCodes, getReasonPhrase } = require('http-status-codes');
const express = require('express');
const { ValidationError } = require('express-validation');
const { logger, errors } = require('./libs');

const app = express();

// add log
app.use((req, res, next) => {
	req.id = ulid();
	logger.info(`${req.id} ${req.method} ${req.originalUrl}`);
	next();
});

// add JSON module
app.use(express.json());

// add urlencoded module
app.use(express.urlencoded({ extended: true }));

// add static module
app.use('/storage', express.static(process.env.STORAGE_DIR));

// add CORS module
app.use(cors());

// add routes
app.use('/api', require('./routes'));

// add successful log
app.use((req, res, next) => {
	if (res.ret) {
		logger.info(`${req.id} successful, output: ${debugFormat(res.ret)}`);
	}
	next();
});

// add error handling
app.use((err, req, res, next) => {
	if (err instanceof ValidationError) {
		err.status = errors.validationFailed.status;
		err.message = errors.validationFailed.message;
		err.data = err.details;
		logger.error(`${req.id} ${err.status} ${getReasonPhrase(err.status)}; validation failed: ${debugFormat(err.data)}`);
	}
	else if (err.status) {
		logger.error(`${req.id} ${err.status} ${getReasonPhrase(err.status)}; ${err.stack}`);
	}
	else {
		logger.error(`${req.id}; ${err.stack}`);
	}

	const code = err.status || StatusCodes.INTERNAL_SERVER_ERROR;
	res.status(code).json({
		error: {
			status: code,
			message: err.message,
			messageLocales: {
				en: i18next.t(err.message, { ...err.options, lng: 'en' }),
				th: i18next.t(err.message, { ...err.options, lng: 'th' }),
			},
			data: err.data,
			ref: req.id,
		}
	}).send();
});

module.exports = app;
