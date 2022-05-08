'use strict';
const util = require('util');

const debugFormat = (o, useUtil) => {
	if (useUtil)
		return util.inspect(o);
	else
		return JSON.stringify(o, undefined, 2);
};

global.debugFormat = debugFormat;
