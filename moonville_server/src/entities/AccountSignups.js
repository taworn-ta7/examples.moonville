'use strict';
const { DataTypes } = require('sequelize');
const db = require('../libs/db');

module.exports = db.define('AccountSignups', {
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

	// locale
	locale: {
		type: DataTypes.STRING(10),
		allowNull: false,
		defaultValue: 'en',
		validate: {
			isIn: [['en', 'th']],
		},
	},

	// encrypted password
	salt: {
		type: DataTypes.STRING,
		allowNull: false,
	},
	hash: {
		type: DataTypes.STRING(1024),
		allowNull: false,
	},

	// confirmation token
	confirmToken: {
		type: DataTypes.STRING(1024),
		allowNull: true,
	},
}, {
	name: {
		singular: 'accountSignup',
		plural: 'accountSignups',
	},
	tableName: 'account_signups',
});
