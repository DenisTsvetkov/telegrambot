const db = require('../../config/Db').db;

exports.schedule = (msg, bot) => {
    const chatId = msg.chat.id;
    
    db.func('get_messages')
    .then(message => {
        bot.sendMessage(chatId, message[0].schedule);
    })
    .catch(error => {
        bot.sendMessage(chatId, 'Произошла ошибка '+error);
    });
    
}

exports.about = (msg, bot) => {
    const chatId = msg.chat.id;
    
    db.func('get_messages')
    .then(message => {
        bot.sendMessage(chatId, message[0].about);
    })
    .catch(error => {
        bot.sendMessage(chatId, 'Произошла ошибка '+error);
    });
}

exports.question = (msg, bot) => {
    const chatId = msg.chat.id;
    
    bot.sendMessage(chatId, 'Задать вопрос!');
}

exports.call = (msg, bot) => {
    const chatId = msg.chat.id;

    var option = {
        "parse_mode": "Markdown",
        "reply_markup": {
            "one_time_keyboard": true,
            "keyboard": [[{
                text: "Мой номер телефона",
                request_contact: true
            }], ["Отмена"]]
        }
    };

    bot.sendMessage(chatId, "Вы выбрали заказать звонок. Оставьте номер телефона, чтобы мы могли связаться с вами.", option).then(() => {
        bot.once("contact",(msg)=>{
            db.func('update_user_phone', [chatId, msg.contact.phone_number])
            .then(message => {
                bot.sendMessage(chatId, 'Отлично, мы свяжемся с вами по номеру телефона: '+msg.contact.phone_number);
            })
            .catch(error => {
                bot.sendMessage(chatId, 'Произошла ошибка '+error);
            });
            // bot.sendMessage(msg.chat.id,
            //                 util.format('Thank you %s with phone %s! And where are you?', msg.contact.first_name, msg.contact.phone_number),
            //                 option)
            //bot.sendMessage(msg.chat.id, 'Ваш телефон '+msg.contact.first_name + ' '+msg.contact.phone_number)

        })
    })
    
    
    //bot.sendMessage(chatId, 'Заказать звонок!');
}

// exports.schedule = schedule;
// exports.about = about;
// exports.question = question;
// exports.call = call;









