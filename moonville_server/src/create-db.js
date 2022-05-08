'use strict';
const { ulid } = require('ulid');
require('./config');
require('./extensions');
const { db } = require('./libs');
const entities = require('./entities');
const { setPassword } = require('./utils/authen');

/**
 * A script to initial database.
 */
(async() => {
    try {
        await db.sync({ force: true });

        const server = 'your.diy';

        {
            const id = ulid();
            const password = setPassword('admin');
            await entities.AccountUsers.create({
                id,
                email: `admin@${server}`,
                role: 'admin',
                name: 'Administrator',
                locale: 'en',
                theme: 15,
            });
            await entities.AccountTokens.create({
                id,
                salt: password.salt,
                hash: password.hash,
            });
        }

        process.exit(0);
    } catch (ex) {
        console.log(ex);
        process.exit(1);
    }
})();