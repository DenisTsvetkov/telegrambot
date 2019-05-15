const db = require('../config/Db').db;


async function all(req, res){
    const result = {};

    // result.loginedUser = req['user']

    const users = await db.func('all_users');
    result.users = users;
    

    const notifications = await db.func('all_notifications');
    result.notifications = notifications;
    console.log(result);

    res.render('users', result);
}

async function changeStatus(req, res){
    try{
        const user = await db.func('change_status', [req.body.chat_id, req.body.new_status]);
        res.status(200).send(user[0]);
    }
    catch(err){
        console.log('Произошла ошибка:', err);
        res.status(404).send({return: 'error'});
    }
}

exports.changeStatus = changeStatus;
exports.all = all;









