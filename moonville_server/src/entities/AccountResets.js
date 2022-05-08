'use strict';
const { DataTypes } = require('sequelize');
const db = require('../libs/db');

module.exports = db.define('AccountResets', {
	// id
	id: {
		type: DataTypes.BIGINT,
		autoIncrement: true,
		primaryKey: true,
	},

	// email
	email: {
		type: DataTypes.STRING(254),
		allowNull: false,
		validate: {
			is: /^[^ \t@]+@[^ \t@.]+\.[^ \t@]+$/,
		},
	},

	// confirmation token
	confirmToken: {
		type: DataTypes.STRING(1024),
		allowNull: true,
	},
}, {
	name: {
		singular: 'accountReset',
		plural: 'accountResets',
	},
	tableName: 'account_resets',
});
