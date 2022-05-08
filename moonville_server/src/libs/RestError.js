'use strict';

class RestError extends Error {
	constructor(error, options) {
		super(error.message);
		this.name = 'RestError';
		this.status = error.status;
		this.options = options;
	}
}

module.exports = RestError;
