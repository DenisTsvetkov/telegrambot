const pgp = require('pg-promise')();
const cn = {
    host: 'localhost',
    port: 5432,
    database: 'telegrambot',
    user: 'postgres',
    password: 'batman59' //password here
};

exports.db = pgp(cn);