'use strict';
const { Sequelize } = require('sequelize');
const path = require('path');
const logger = require('./logger');

const env = process.env;

let db;
if (env.DB_USE === 'mysql') {
	const host = env.DB_HOST;
	const port = env.DB_PORT;
	const username = env.DB_USERNAME;
	const password = env.DB_PASSWORD;
	const database = env.DB_DATABASE;
	const logging = +env.DB_LOGGING;

	logger.info(`connecting to: mysql://${host}:${port}/${database}, with '${username}'`);
	db = new Sequelize(database, username, password, {
		host,
		port,
		dialect: 'mysql',
		logging: logging ? console.log : false,
	});
}
else if (env.DB_USE === 'sqlite') {
	const datafile = env.DB_DATAFILE;
	const logging = +env.DB_LOGGING;

	logger.info(`connecting to: sqlite://storage/${datafile}`);
	db = new Sequelize({
		storage: path.join(env.STORAGE_PATH, datafile),
		dialect: 'sqlite',
		logging: logging ? console.log : false,
	});
}

module.exports = db;
