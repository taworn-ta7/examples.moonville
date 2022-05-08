'use strict';
const path = require('path');
const i18next = require('i18next');
const backend = require('i18next-fs-backend');
require('./config');
require('./extensions');
const { logger, db } = require('./libs');
require('./entities');
require('./tasks');
const app = require('./express');

/**
 * Main program.
 */
(async () => {
	try {
		// initialize i18next
		await i18next.use(backend).init({
			fallbackLng: 'en',
			lng: 'en',
			preload: ['en', 'th'],
			ns: ['errors'],
			defaultNS: 'errors',
			backend: {
				loadPath: path.join(__dirname, 'locales', '{{lng}}', '{{ns}}.json'),
			},
		});

		// initialize database
		await db.sync({ force: false });

		// listen to port
		const port = process.env.HTTP_PORT;
		app.listen(port, () => logger.info(`server listening on port: ${port}`));
	}
	catch (ex) {
		logger.error(ex);
	}
})();
