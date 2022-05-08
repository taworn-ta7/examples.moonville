# Moonville

The Moonville is an umbrella project that contains:

* moonville_server: APIs server
* moonville_client_dart: client connection library
* moonville_app: demo app
* moonville_web: demo web, compatible with moonville_app

## Features

These samples demostration of these features:

* User tables
* Send mail in signup and forgot password
* Can send mail in emulation or real server
* Delete unused records after n days, configurable
* Profile and changing
* Upload/view profile icon
* Change language: English, Thai
* Change theme color
* View data list, complete with paging, sorting, searching and including loading icons in background
* Remember login
* Postman for testing
* Sign-in to Google and LINE, on web version only
	+ Sorry, facebook sign-in is still not work T_T
		- may be facebook need real domain and https, not sure.

## Screenshots

Screenshots are in linked files:

* [App on Android Screenshots](https://htmlpreview.github.io/?https://github.com/taworn-ta7/examples.moonville/blob/main/doc/screens-app_on_android.html)
* [App on Windows Screenshots](https://htmlpreview.github.io/?https://github.com/taworn-ta7/examples.moonville/blob/main/doc/screens-app_on_win.html)
* [App on Web Screenshots](https://htmlpreview.github.io/?https://github.com/taworn-ta7/examples.moonville/blob/main/doc/screens-app_on_web.html)
* [Web Screenshots](https://htmlpreview.github.io/?https://github.com/taworn-ta7/examples.moonville/blob/main/doc/screens-web.html)

## Installation

If you not installed development tools, installs them now:

* [Node](https://nodejs.org/), for moonville_server
* [Dart](https://dart.dev/), for moonville_client_dart, not important
* [Flutter](https://flutter.dev/), for moonville_app
* [React](https://reactjs.org/) and [modern web browser](https://www.google.com/chrome/), for moonville_web.

## Run Server

Install moonville_server:

	cd %BASE_PATH%/examples.moonville/moonville_server

	npm i            ; a long time waiting!
	npm run create

These will setup server with database is SQLite and mail is emulate.  You can open moonville_server/.env.base and edit:

* choose database between: DB_USE=sqlite or DB_USE=mysql
* set MAIL_EMU=1 (emulate, send mail to you) or MAIL_EMU=0 (real mail server)
* create blank MySQL database: moonville, if you use MySQL
* if you switch to new database, run "npm run create" again
* if you run "npm run create" with data in database, ALL DATA WILL BE DELETED!

Then, type command:

	npm start

To run the server.

## Run Web

Install React modules, by:

	cd %BASE_PATH%/examples.moonville/moonville_web

	npm i            ; a long time waiting!

Then, type command:

	npm start

It will open browser and run this address:

	http://localhost:3000/

## Run App

You can run moonville_app, by these commands:

	cd %BASE_PATH%/examples.moonville/moonville_app

	flutter run            ; flutter will show list of platforms to run

## Run App On Android

If you run on Android, you need to setup IP.  I recommend [ngrok](https://ngrok.com/).  Install program ngrok and run:

	ngrok http 7000

You will get temporary internet host address, copy and paste to %BASE_PATH%/examples.moonville/moonville_app/lib/constants.dart.  Here is an sample:

	class Constants {
		/// Server base URI.
		//static const baseUri = 'http://localhost:7000/api';
		static const baseUri = 'https://c441-49-228-96-99.ngrok.io/api';

		/// Static server base URI.
		//static const baseStaticUri = 'http://localhost:7000';
		static const baseStaticUri = 'https://c441-49-228-96-99.ngrok.io';
	}

Compile and run on Android.

## Admin User

There will be created admin user, for testing:

* username: admin@your.diy
* password: admin

## Mail Emulation

If you have set MAIL_EMU=1 or leave defaults, you get mail emulation mode.  In this mode, all mail sent will go to https://ethereal.email.  Please login and input MAIL_EMU_USERNAME and MAIL_EMU_PASSWORD in .env.base, and go to messages screen.  Or, go to https://ethereal.email/create and create your own mailbox.

## Keep Logs

When logs and database logging, account_signups and account_resets tables has go too old.  Program server will delete them.  You can change number of days to keep before delete. Open .env.base and change DAYS_TO_KEEP_*. You also have to restart server.

## Postman

If you want to test with Postman. Choose import from Postman, and navigate to directory %BASE_PATH%/examples.moonville/moonville_server, choose two files:

* moonville.postman_collection.json
* moonville.postman_environment.json

You are ready to test with Postman.

## BUGs

There may be some bugs, too. I founds something about exception when exit, but only run debug mode. Don't know how to fix, because it doesn't happen again. Sorry Y_Y

Another downgrade is web form validator, it's will display English, or may I think it's your browser locale, not my web's locale.

## Last

Sorry, but I'm not good at English. T_T

Taworn Ta.
