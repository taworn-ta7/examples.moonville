'use strict';
const { DataTypes } = require('sequelize');
const db = require('../libs/db');

module.exports = db.define('AccountTokens', {
	// id
	id: {
		type: DataTypes.STRING(50),
		primaryKey: true,
	},

	// ----------------------------------------------------------------------

	// encrypted password
	salt: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	hash: {
		type: DataTypes.STRING(1024),
		allowNull: false,
	},
	token: {
		type: DataTypes.STRING(1024),
		allowNull: true,
	},
}, {
	name: {
		singular: 'accountToken',
		plural: 'accountTokens',
	},
	tableName: 'account_tokens',
});
