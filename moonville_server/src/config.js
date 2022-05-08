'use strict';
const path = require('path');
const fs = require('fs');
const dotenv = require('dotenv');

dotenv.config();
if (process.env.NODE_ENV === 'development') {
	dotenv.config({ path: path.join(__dirname, '..', '.env.base-development') });
}
if (process.env.NODE_ENV === 'production') {
	dotenv.config({ path: path.join(__dirname, '..', '.env.base-production') });
}
dotenv.config({ path: path.join(__dirname, '..', '.env.base') });

(async () => {
	process.env.TEMP_PATH = path.resolve(path.join(__dirname, '..', process.env.TEMP_DIR));
	process.env.STORAGE_PATH = path.resolve(path.join(__dirname, '..', process.env.STORAGE_DIR));
	await fs.promises.mkdir(process.env.TEMP_PATH, { recursive: true });
	await fs.promises.mkdir(process.env.STORAGE_PATH, { recursive: true });
})();
