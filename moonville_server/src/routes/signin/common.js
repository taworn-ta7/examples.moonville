'use strict';
const { ulid } = require('ulid');
const { RestError, errors, db } = require('../../libs');
const entities = require('../../entities');
const { setPassword, generateToken } = require('../../utils/authen');

/**
 * Prepare account user for external sign-in.
 */
const userForExternalSignIn = async (email, name, locale) => {
	// check if email is exists
	let user = await entities.AccountUsers.findOne({
		where: { email },
		include: entities.AccountTokens,
	});

	// not found, create it
	if (!user) {
		// check locale
		if (locale !== 'en' && locale !== 'th')
			locale = 'en';

		// create user
		const id = ulid();
		const generate = generateToken().substring(0, 8);
		const password = setPassword(generate);
		let token;
		await db.transaction(async (t) => {
			user = await entities.AccountUsers.create({
				id,
				email,
				name,
				locale,
				role: 'user',
			}, { transaction: t });
			token = await entities.AccountTokens.create({
				id,
				salt: password.salt,
				hash: password.hash,
			}, { transaction: t });
		});
		user.accountToken = token;
		return { user, created: true };
	}
	else {
		// check if user disabled or unregistered
		if (user.resigned)
			throw new RestError(errors.userIsResigned);
		if (user.disabled)
			throw new RestError(errors.userIsDisabledByAdmin);
		return { user, created: false };
	}
}

// ----------------------------------------------------------------------

module.exports = {
	userForExternalSignIn,
};
