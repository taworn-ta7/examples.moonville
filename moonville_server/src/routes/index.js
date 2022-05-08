'use strict';
const router = require('express').Router();

router.use('/', require('./test'));
router.use('/accounts', require('./accounts/signup'));
router.use('/accounts', require('./accounts/reset'));
router.use('/authen', require('./authen'));
router.use('/authen/google', require('./signin/google'));
router.use('/authen/facebook', require('./signin/facebook'));
router.use('/authen/line', require('./signin/line'));
router.use('/profile', require('./profile/icon'));
router.use('/profile', require('./profile/name'));
router.use('/profile', require('./profile/password'));
router.use('/settings', require('./settings'));
router.use('/accounts/users', require('./accounts/users'));

module.exports = router;
