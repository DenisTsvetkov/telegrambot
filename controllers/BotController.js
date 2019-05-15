const db = require('../config/Db').db;

// async function spam(msg, bot){
//     const chatId = msg.chat.id;
//     let users = await db.func('all_users');
//     let news = await db.func('get_newsletter');

//     console.log('ЮЗУРЕ', users);
//     var checkRandom = [];
//     setInterval(function(){
        
//         users.forEach(function callback(value, index, users) {
//             var random = getRandomInt(0, news.length);
//             if(random != checkRandom[users[index].id]){
//                 try{
//                     bot.sendMessage(users[index].id, `${users[index].firstname} ${news[random].content}`);
//                 }
//                 catch(err){
//                     console.log(`Пользователь ${users[index].username} недоступен`);
//                 }
//                 checkRandom[users[index].id] = random;
//             }
//         });
//      },5000);
// }

// exports.spam = spam;

async function sendMsgToUser(req, res, bot){
    console.log(bot);
    console.log(req.body);
    let chatId = parseInt(req.body.chatId);
    let msg = req.body.msg;
    
        bot.sendMessage(chatId, `${msg}`)
        .then(message=>{
            console.log(`Пользователь доступен`);

            res.status(200).redirect('back');
        })
        .catch(function(error){
            console.log(`Пользователь недоступен`);
            db.func('set_user_active', [chatId, false])
            res.status(403).redirect('back');
        })
    
}

async function sendMsgToAllUsers(req, res, bot){
    let msg = req.body.msg;

    let users = await db.func('all_users');
    users.forEach(function callback(user, index, users) {
        setTimeout(function(){
            console.log(`Отправляем сообщение ${user.username} статус: ${user.active}`)
            if(user.active == true){
                    bot.sendMessage(user.id, `${msg}`)
                    .catch(function(err){
                        console.log(`Пользователь ${user.username} недоступен. Ошибка: ${err}`);
                        db.func('set_user_active', [user.id, false]);
                    });
            }
        }, 500);
    });

    res.status(200).redirect('back');
}

exports.sendMsgToAllUsers = sendMsgToAllUsers;

exports.sendMsgToUser = sendMsgToUser;





