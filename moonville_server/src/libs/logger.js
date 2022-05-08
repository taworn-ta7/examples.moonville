'use strict';
const path = require('path');
const fs = require('fs');
const { createLogger, format, transports } = require('winston');
require('winston-daily-rotate-file');

const logDir = path.resolve(path.join(__dirname, '..', '..', process.env.LOG_DIR));
if (!fs.existsSync(logDir)) {
	fs.mkdirSync(logDir);
}

const logger = createLogger({
	level: process.env.NODE_ENV === 'production' ? 'info' : 'silly',
	format: format.combine(
		format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss.SSS' }),
		format.printf(info => `${info.timestamp} ${info.level.substring(0, 3).toUpperCase()} ${info.message}`),
	),
	transports: [
		new transports.Console({}),
		new transports.DailyRotateFile({
			filename: `${logDir}/%DATE%.log`,
			datePattern: 'YYYYMMDD',
		}),
	],
});

module.exports = logger;
