'use strict';
const nodemailer = require('nodemailer');

const env = process.env;

let transporter;
if (+env.MAIL_EMU) {
	const host = env.MAIL_EMU_HOST;
	const port = env.MAIL_EMU_PORT;
	const username = env.MAIL_EMU_USERNAME;
	const password = env.MAIL_EMU_PASSWORD;

	transporter = nodemailer.createTransport({
		host,
		port,
		auth: {
			user: username,
			pass: password,
		}
	});
}
else {
	const host = env.MAIL_REAL_HOST;
	const port = env.MAIL_REAL_PORT;
	const username = env.MAIL_REAL_USERNAME;
	const password = env.MAIL_REAL_PASSWORD;

	transporter = nodemailer.createTransport({
		host,
		port,
		auth: {
			user: username,
			pass: password,
		}
	});
}

const send = async (mailOptions) => {
	return await transporter.sendMail(mailOptions);
};

module.exports = {
	send,
};
