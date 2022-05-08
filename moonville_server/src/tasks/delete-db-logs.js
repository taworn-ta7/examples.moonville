'use strict';
const { Op } = require('sequelize');
const { format } = require('date-and-time');
const { logger } = require('../libs');
const entities = require('../entities');

const deleteDbLogs = async (daysToKeep) => {
    // check before execute, days to keep must keep at least 0 (today) 
    if (daysToKeep < 0)
        return;

    // compute date range
    const now = new Date();
    const end = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const begin = new Date(end.valueOf() - (daysToKeep * 24 * 60 * 60 * 1000));

    // delete signups data
    logger.debug(`database logs data older than ${format(begin, 'YYYY-MM-DD')} will be delete!`);
    await entities.Loggings.destroy({
        where: {
            createdAt: {
                [Op.lt]: begin,
            }
        }
    });
};

module.exports = deleteDbLogs;
