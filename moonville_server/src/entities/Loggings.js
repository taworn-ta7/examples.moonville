'use strict';
const { DataTypes } = require('sequelize');
const db = require('../libs/db');

module.exports = db.define('Loggings', {
	// id
	id: {
		type: DataTypes.BIGINT,
		autoIncrement: true,
		primaryKey: true,
	},

	// who do an action
	userId: {
		type: DataTypes.STRING(50),
		allowNull: false,
		field: 'user_id',
	},

	// create, update and delete
	action: {
		type: DataTypes.STRING(50),
		allowNull: false,
	},

	// which table
	table: {
		type: DataTypes.STRING(100),
		allowNull: false,
	},

	// description
	description: {
		type: DataTypes.TEXT,
		allowNull: false,
	},
}, {
	name: {
		singular: 'logging',
		plural: 'loggings',
	},
	tableName: 'loggings',
});
