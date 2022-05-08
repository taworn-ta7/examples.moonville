'use strict';
const { Joi } = require('express-validation');
module.exports = {

	// page index
	page: Joi.number().integer()
		.min(0).max(999999999)
		.allow(''),

	// order by
	order: Joi.string()
		.allow('', null),

	// search
	search: Joi.string()
		.allow('', null),

	// in trash
	trash: Joi.number().integer()
		.min(0).max(1)
		.allow(''),

};
