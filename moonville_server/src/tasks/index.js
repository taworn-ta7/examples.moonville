'use strict';
const path = require('path');
const logger = require('../libs/logger');
const deleteLogs = require('./delete-logs');
const deleteDbLogs = require('./delete-db-logs');
const deleteSignups = require('./delete-signups');
const deleteResets = require('./delete-resets');

const deleteLogTimer = async (parameter) =>
	await deleteLogs(parameter.daysToKeep, parameter.logPath);

const deleteDbLogTimer = async (parameter) =>
	await deleteDbLogs(parameter.daysToKeep);

const deleteSignupsTimer = async (parameter) =>
	await deleteSignups(parameter.daysToKeep);

const deleteResetsTimer = async (parameter) =>
	await deleteResets(parameter.daysToKeep);

/**
 * Install all background tasks.
 */
(() => {
	try {
		const delayTime = 10 * 1000;
		const intervalTime = 8 * 60 * 60 * 1000;
		const logPath = path.resolve(path.join(__dirname, '..', '..', process.env.LOG_DIR));
		logger.info(`log path: ${logPath}`);

		{
			// logs
			const daysToKeep = +process.env.DAYS_TO_KEEP_LOGS;
			logger.info(`days to keep logs: ${daysToKeep} day(s)`);
			setTimeout(deleteLogTimer, delayTime, { daysToKeep, logPath });
			setInterval(deleteLogTimer, intervalTime, { daysToKeep, logPath });
		}

		{
			// db logs
			const daysToKeep = +process.env.DAYS_TO_KEEP_DBLOGS;
			logger.info(`days to keep database logs: ${daysToKeep} day(s)`);
			setTimeout(deleteDbLogTimer, delayTime, { daysToKeep, logPath });
			setInterval(deleteDbLogTimer, intervalTime, { daysToKeep, logPath });
		}

		{
			// unconfirmed signups
			const daysToKeep = +process.env.DAYS_TO_KEEP_SIGNUPS;
			logger.info(`days to keep unconfirmed signups: ${daysToKeep} day(s)`);
			setTimeout(deleteSignupsTimer, delayTime, { daysToKeep });
			setInterval(deleteSignupsTimer, intervalTime, { daysToKeep });
		}

		{
			// unconfirmed resets
			const daysToKeep = +process.env.DAYS_TO_KEEP_RESETS;
			logger.info(`days to keep unresponded resets: ${daysToKeep} day(s)`);
			setTimeout(deleteResetsTimer, delayTime, { daysToKeep });
			setInterval(deleteResetsTimer, intervalTime, { daysToKeep });
		}
	}
	catch (ex) {
		logger.error(ex);
	}
})();
