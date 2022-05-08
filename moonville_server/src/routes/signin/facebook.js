'use strict';
const path = require('path');
const fs = require('fs');
const fetch = require('node-fetch');
const queryString = require('query-string');
const { StatusCodes } = require('http-status-codes');
const router = require('express').Router();
const asyncHandler = require('express-async-handler');
const { logger, RestError, errors } = require('../../libs');
const entities = require('../../entities');
const { newOrUpdateToken } = require('../../utils/authen');
const { userForExternalSignIn } = require('./common');

router.get('/', [
], asyncHandler(async (req, res, next) => {
	// get request
	const { code, state } = req.query;
	const redirectUri = `http://localhost:3000/signin/facebook`;
	logger.debug(`${req.id} code: ${code}`);
	logger.debug(`${req.id} state: ${state}`);

	// ask for token
	let token;
	{
		// call service
		const uri = `https://graph.facebook.com/v13.0/oauth/access_token?${queryString.stringify({
			code,
			client_id: process.env.FACEBOOK_CLIENT_ID,
			client_secret: process.env.FACEBOOK_CLIENT_SECRET,
			redirect_uri: redirectUri,
		})}`;
		const options = {
			method: 'GET',
			/*
			headers: {
				'Content-Type': 'application/json;charset=utf-8',
			},
			*/
		};

		// retrieve response
		const res = await fetch(uri, options);
		if (res.status !== 200) {
			logger.debug(`${req.id} ${res.status} ${res.statusText} ${uri}`);
			try {
				const json = await res.json();
				logger.debug(`${req.id} json: ${debugFormat(json)}`);
			}
			catch (ex) {
				logger.debug(`${req.id} json: no data`);
			}
			throw new RestError(errors.invalidSignInExternal);
		}

		// check data
		token = await res.json();
		logger.debug(`${req.id} token: ${debugFormat(token)}`);
		if (!token.access_token || !token.id_token) {
			throw new RestError(errors.invalidSignInExternal);
		}
	}

	// ask for user information
	let info;
	{
		// call service
		const uri = `https://www.facebookapis.com/oauth2/v1/userinfo?alt=json&access_token=${token.access_token}`;
		const options = {
			method: 'GET',
			headers: {
				'Authorization': `Bearer ${token.id_token}`,
			},
		};

		// retrieve response
		const res = await fetch(uri, options);
		if (res.status !== 200) {
			logger.debug(`${req.id} ${res.status} ${res.statusText} ${uri}`);
			throw new RestError(errors.invalidSignInExternal);
		}

		// check data
		info = await res.json();
		logger.debug(`${req.id} user: ${debugFormat(info)}`);
		if (!info.email || !info.name) {
			throw new RestError(errors.invalidSignInExternal);
		}
	}

	// create or select user
	const { user, created } = await userForExternalSignIn(info.email, info.name, info.locale);

	// check if expiry login
	const newToken = await newOrUpdateToken(user);

	// if just created and have profile
	if (created && info.picture) {
		// load profile icon from host
		const res = await fetch(info.picture);
		if (res.status === 200) {
			const blob = await res.blob();

			// create directory, if not exists
			const dir = path.join(process.env.STORAGE_PATH, user.id, 'profile');
			await fs.promises.mkdir(dir, { recursive: true });

			// delete old image file, if it exists
			const iconFile = path.join(dir, `icon`);
			try {
				await fs.promises.access(iconFile);
				await fs.promises.rm(iconFile);
			}
			catch (ex) {
			}

			// write blob
			const array = await blob.arrayBuffer();
			const buffer = Buffer.from(array);
			await fs.promises.writeFile(iconFile, buffer);

			// write mime
			const mimeFile = path.join(dir, `icon-mime`);
			await fs.promises.writeFile(mimeFile, 'image/png');
		}
	}

	// insert log
	await entities.Loggings.create({
		userId: user.id,
		action: 'update',
		table: 'AccountUsers',
		description: `User ${user.id} is sign-in from Facebook.`,
	});

	// success
	res.ret = {
		user: await entities.AccountUsers.findByPk(user.id),
		token: newToken,
	};
	res.status(StatusCodes.OK).send(res.ret);
	next();
}));

module.exports = router;
