'use strict';
const { Joi } = require('express-validation');
module.exports = {

	email: Joi.string()
		.min(5).max(254)
		.email({ tlds: false }),

	role: Joi.string()
		.max(50)
		.valid('user', 'admin'),

	name: Joi.string()
		.min(1).max(100),

	locale: Joi.string()
		.max(10)
		.valid('en', 'th'),

	theme: Joi.number().integer()
		.min(0).max(15),

	disabled: Joi.boolean(),

	resigned: Joi.boolean(),

	password: Joi.string()
		.min(4).max(20),

};
