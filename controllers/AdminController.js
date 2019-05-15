const db = require('../config/Db').db;

async function show(req, res){
    const result = {};
    const notifications = await db.func('all_notifications');
    result.notifications = notifications;
    console.log(result);
    res.render('index', result);
}

async function info(req, res){
    const result = {};
    const messages = await db.func('get_messages');
    result.messages = messages[0];

    const notifications = await db.func('all_notifications');
    result.notifications = notifications;
    console.log(result);

    res.render('info', result);
}

async function readNotifications(req, res){
    await db.func('read_all_notification');
    res.status(200).send({result:'read_all_notifications'});
}

exports.readNotifications = readNotifications;
exports.show = show;
exports.info = info;
