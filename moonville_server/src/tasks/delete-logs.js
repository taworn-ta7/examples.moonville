'use strict';
const path = require('path');
const fs = require('fs');
const { format } = require('date-and-time');
const { logger } = require('../libs');

const deleteLogs = async (daysToKeep, directory) => {
    // check before execute, days to keep must keep at least 0 (today) 
    if (daysToKeep < 0)
        return;

    // compute date range
    const now = new Date();
    const end = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const begin = new Date(end.valueOf() - (daysToKeep * 24 * 60 * 60 * 1000));

    // loop for delete files
    logger.debug(`logs older than ${format(begin, 'YYYY-MM-DD')} will be delete!`);
    const files = await fs.promises.readdir(directory);
    const re = /^([0-9]{4})([0-9]{2})([0-9]{2})\.log$/;
    for (let i = 0; i < files.length; i++) {
        const file = files[i];
        const found = file.match(re);
        if (found) {
            const date = new Date(Date.UTC(Number(found[1]), Number(found[2]) - 1, Number(found[3])));
            if (date.valueOf() < begin.valueOf()) {
                logger.debug(`delete: ${file}`);
                await fs.promises.rm(path.join(directory, file));
            }
        }
    }
};

module.exports = deleteLogs;
