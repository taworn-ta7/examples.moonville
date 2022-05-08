'use strict';
const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const { RestError, errors, db } = require('../libs');
const entities = require('../entities');

const setPassword = (password) => {
	const salt = crypto.randomBytes(16).toString('hex');
	const hash = crypto.pbkdf2Sync(password, salt, 10000, 512, 'sha512').toString('hex');
	return { salt, hash };
};

const validatePassword = (password, salt, hash) => {
	const computeHash = crypto.pbkdf2Sync(password, salt, 10000, 512, 'sha512').toString('hex');
	return hash === computeHash;
};

const generateSecret = () => {
	const seed = crypto.randomBytes(128).toString('hex');
	return Buffer.from(seed).toString('base64');
};

const generateToken = () => {
	const seed = crypto.randomBytes(128).toString('hex');
	const code = Buffer.from(seed).toString('base64');
	return code.substring(0, 64);
};

// ----------------------------------------------------------------------

const newOrUpdateToken = async (user) => {
	let token;
	const now = new Date();
	if (user.accountToken.token && user.expire && user.expire.getTime() >= now.getTime()) {
		// update expiry login
		const expire = now.getTime() + +process.env.AUTHEN_TIMEOUT;
		await user.update({
			expire: new Date(expire),
		});
		token = user.accountToken.token;
	}
	else {
		// sign token
		const now = new Date();
		const expire = now.getTime() + +process.env.AUTHEN_TIMEOUT;
		const payload = {
			id: user.id,
			sub: user.email,
		};
		const secret = generateSecret();
		token = await jwt.sign(payload, secret, {});

		// update user
		await db.transaction(async (t) => {
			await user.update({
				begin: now,
				end: null,
				expire: new Date(expire),
			}, { transaction: t });
			await user.accountToken.update({
				token: token,
			}, { transaction: t });
		});
	}
	return token;
};

// ----------------------------------------------------------------------

const tokenFromHeaders = (req) => {
	const { headers: { authorization } } = req;
	if (authorization) {
		const a = authorization.split(' ');
		if (a.length >= 2) {
			if (a[0].toLowerCase() === 'bearer') {
				return a[1];
			}
		}
	}
	return null;
};

const userFromHeaders = async (req) => {
	const token = tokenFromHeaders(req);
	if (!token)
		throw new RestError(errors.invalidToken);

	// search token
	const user = await entities.AccountUsers.findOne({
		include: {
			model: entities.AccountTokens,
			where: { token },
		},
	});
	if (!user)
		throw new RestError(errors.invalidToken);

	// check if expiry login
	const now = new Date();
	if (user.expire.getTime() < now.getTime())
		throw new RestError(errors.timeout);

	// update expiry login
	const expire = now.getTime() + +process.env.AUTHEN_TIMEOUT;
	await user.update({
		expire: new Date(expire),
	});
	return user;
};

module.exports = {
	setPassword,
	validatePassword,
	generateSecret,
	generateToken,
	newOrUpdateToken,
	tokenFromHeaders,
	userFromHeaders,
};
