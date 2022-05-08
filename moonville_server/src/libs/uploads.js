'use strict';
const multer = require('multer');
const { ulid } = require('ulid');

const storage = multer.diskStorage({
	destination: (req, file, callback) => {
		callback(null, process.env.TEMP_PATH);
	},
	filename: (req, file, callback) => {
		const id = ulid();
		callback(null, id);
	},
});
const uploads = multer({ storage });

module.exports = uploads;
