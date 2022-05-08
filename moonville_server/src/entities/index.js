'use strict';
const AccountUsers = require('./AccountUsers');
const AccountTokens = require('./AccountTokens');
const AccountSignups = require('./AccountSignups');
const AccountResets = require('./AccountResets');
const Loggings = require('./Loggings');

// AccountUsers => AccountTokens
AccountUsers.hasOne(AccountTokens, { foreignKey: 'id' });
AccountTokens.belongsTo(AccountUsers, { foreignKey: 'id' });

module.exports = {
	AccountUsers,
	AccountTokens,
	AccountSignups,
	AccountResets,
	Loggings,
};
