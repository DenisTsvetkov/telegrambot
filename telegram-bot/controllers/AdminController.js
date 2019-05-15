const db = require('../../config/Db').db;
require('dotenv').config()

function is_admin(id, chatId, bot, callback){
    if(id == parseInt(process.env.ADMIN_ID)){
        callback();
    }
    else{
        bot.sendMessage(chatId, `Ошибка доступа. Вы не обладаете правами администратора`);
    }
}

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min)) + min;
}



exports.entry = (msg, bot) => {
    const chatId = msg.chat.id;
    console.log(msg);
    //stages[chatId] = 1;
    is_admin(parseInt(msg.from.id), chatId, bot, function(){
        bot.sendMessage(chatId, `Здравствуйте администратор ${msg.from.first_name} ${msg.from.last_name}`, {
            reply_markup: {
                keyboard:[
                    [
                        {text: 'Изменить расписание'},
                        {text: 'Изменить "О клубе"'}
                    ],
                    [
                        {text: 'Управление рассылкой'},
                        {text: 'Сменить пароль'},
                    ],
                    [
                        {text: 'Посмотреть подписчиков'}
                    ],
                    [
                        {text: 'Рассылка'}
                    ]
                ],
                resize_keyboard: true
            }
            });
    })
}


// exports.spam = (msg, bot) => {
//     const chatId = msg.chat.id;
//     db.func('all_users').
//     then(users => {
//             var checkRandom;
//             users.forEach(function callback(value, index, users) {
//               db.func('get_newsletter')
//               .then(news =>{
//                 setInterval(function(){
//                    var random = getRandomInt(0, news.length);
//                     if(random != checkRandom){
//                         bot.sendMessage(users[index].id, news[getRandomInt(0, news.length)].content);
//                         checkRandom = random;
//                     }
//                 },5000);
//               }) 
//             });
//     })
//     .catch(error => {

//     })
    
// }

async function spam(msg, bot){
    const chatId = msg.chat.id;
    let users = await db.func('all_users');
    let news = await db.func('get_newsletter');

    console.log('ЮЗУРЕ', users);
    var checkRandom = [];
    setInterval(function(){
        
        users.forEach(function callback(value, index, users) {
            var random = getRandomInt(0, news.length);
            if(random != checkRandom[users[index].id]){
                try{
                    bot.sendMessage(users[index].id, `${users[index].firstname} ${news[random].content}`);
                }
                catch(err){
                    console.log(`Пользователь ${users[index].username} недоступен`);
                }
                checkRandom[users[index].id] = random;
            }
        });
     },5000);
}

exports.spam = spam;


exports.changeScheduleBtn = (msg, bot)=>{
    
    const chatId = msg.chat.id;
    is_admin(parseInt(msg.from.id), chatId, bot, function(){
        bot.sendMessage(chatId, 'Введите текст расписания с помощью команды: \n/new_rasp <...Текст...>');
    })
}


exports.changeSchedule = (msg, bot, match)=>{
    const chatId = msg.chat.id;
    is_admin(parseInt(msg.from.id), chatId, bot, function(){
        console.log(match);
        db.func('update_schedule', match[1])
        .then(suc =>{
            bot.sendMessage(chatId, 'Текст расписания успешно изменен');
        })
        .catch(error => {
            bot.sendMessage(chatId, `Произошла ошибка: ${error}`);
        })
    });
}

exports.changeAboutBtn = (msg, bot)=>{
    
    const chatId = msg.chat.id;
    is_admin(parseInt(msg.from.id), chatId, bot, function(){
        bot.sendMessage(chatId, 'Введите текст расписания с помощью команды: \n/new_about <...Текст...>');
    })
}


exports.changeAbout = (msg, bot, match)=>{
    const chatId = msg.chat.id;
    is_admin(parseInt(msg.from.id), chatId, bot, function(){
        console.log(match);
        db.func('update_about', match[1])
        .then(suc =>{
            bot.sendMessage(chatId, 'Текст "О клубе" изменен');
        })
        .catch(error => {
            bot.sendMessage(chatId, `Произошла ошибка: ${error}`);
        })
    });
}





