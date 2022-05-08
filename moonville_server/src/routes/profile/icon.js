'use strict';
const path = require('path');
const fs = require('fs');
const mime = require('mime-types');
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { logger, RestError, errors, uploads } = require('../../libs');
const entities = require('../../entities');
const { dump, authen } = require('../../middlewares');

/**
 * Upload a profile icon.
 */
router.post('/icon', [
	authen.required,
	uploads.single('image'),
	dump.headers,
], asyncHandler(async (req, res, next) => {
	// check upload image
	const image = req.file;
	if (!image)
		throw new RestError(errors.noUploadFile);
	logger.verbose(`${req.id} image: ${debugFormat(image, true)}`);
	if (image.mimetype !== 'image/png' && image.mimetype !== 'image/jpeg' && image.mimetype !== 'image/gif')
		throw new RestError(errors.uploadFileIsNotType, { context: 'image' });
	if (image.size >= +process.env.PROFILE_ICON_FILE_LIMIT)
		throw new RestError(errors.uploadFileIsTooLarge);

	// create directory, if not exists
	const dir = path.join(process.env.STORAGE_PATH, req.user.id, 'profile');
	await fs.promises.mkdir(dir, { recursive: true });

	// generate output
	const name = `icon`;
	const part = `/storage/${req.user.id}/profile`;
	const host = req.get('host');
	const protocol = req.protocol;

	// delete old image file, if it exists
	const iconFile = path.join(dir, `icon`);
	try {
		await fs.promises.access(iconFile);
		await fs.promises.rm(iconFile);
	}
	catch (ex) {
	}

	// write mime
	const mimeFile = path.join(dir, `icon-mime`);
	await fs.promises.writeFile(mimeFile, image.mimetype);

	// move file
	await fs.promises.rename(image.path, iconFile);

	// insert log
	await entities.Loggings.create({
		userId: req.user.id,
		action: 'update',
		table: 'AccountUsers',
		description: `User ${req.user.id} upload profile icon.`,
	});

	// success
	res.ret = {
		image: {
			protocol,
			host,
			path: part,
			name,
			uri: `${protocol}://${host}${part}/${name}`,
		},
	};
	res.status(StatusCodes.CREATED).send(res.ret);
	next();
}));

/**
 * View profile icon.
 */
router.get('/icon', [
	authen.required,
], asyncHandler(async (req, res, next) => {
	// view icon file
	const dir = path.join(process.env.STORAGE_PATH, req.user.id, 'profile');
	const iconFile = path.join(dir, `icon`);
	const mimeFile = path.join(dir, `icon-mime`);
	let data;
	let contentType;
	try {
		await fs.promises.access(iconFile);
		data = await fs.promises.readFile(iconFile);
		contentType = await fs.promises.readFile(mimeFile);
	}
	catch (ex) {
		const defaultFile = path.resolve(path.join(__dirname, '../..', 'assets', 'default-profile-icon.png'));
		data = await fs.promises.readFile(defaultFile);
		contentType = mime.contentType(defaultFile);
	}

	// output
	res.writeHead(StatusCodes.OK, { 'Content-Type': contentType });
	res.end(data);
}));

/**
 * Remove the uploaded profile icon.
 */
router.delete('/icon', [
	authen.required,
], asyncHandler(async (req, res, next) => {
	// delete icon and mime files
	const dir = path.join(process.env.STORAGE_PATH, req.user.id, 'profile');
	const iconFile = path.join(dir, `icon`);
	const mimeFile = path.join(dir, `icon-mime`);
	try {
		await fs.promises.access(iconFile);
		await fs.promises.rm(iconFile);
	}
	catch (ex) {
	}
	try {
		await fs.promises.access(mimeFile);
		await fs.promises.rm(mimeFile);
	}
	catch (ex) {
	}

	// insert log
	await entities.Loggings.create({
		userId: req.user.id,
		action: 'update',
		table: 'AccountUsers',
		description: `User ${req.user.id} delete profile icon.`,
	});

	// success
	res.ret = {
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
