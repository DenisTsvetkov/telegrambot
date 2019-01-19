const TelegramBot = require('node-telegram-bot-api');

const token = '571499408:AAEtxaMQ6RqbdpYK80SSa_T0vYNvLASLQ3g';

const bot = new TelegramBot(token, {polling: true});

let users = [];


bot.onText(/\/start/, (msg, match) => {

  const chatId = msg.chat.id;
  
  users[chatId]= {
    'uid': msg.from.id,
    'chatId': msg.chat.id,
    'ufirstname': msg.chat.first_name,
    'ulastname': msg.chat.last_name
  };

  bot.sendMessage(chatId, 'Главное меню', {
    reply_markup: {
      keyboard:[
        [
          {text: 'Узнать расписание'},
          {text: 'О клубе'},
          {text: 'Задать вопрос'},
          {text: 'Заказать звонок'}
        ]
      ],
      resize_keyboard: true
    }
  });
});

bot.onText(/Узнать расписание/, (msg, match) => {
  const chatId = msg.chat.id;
  bot.sendMessage(chatId, 'АКТУАЛЬНОЕ РАСПИСАНИЕ');
});

bot.onText(/О клубе/, (msg, match) => {
  const chatId = msg.chat.id;
  bot.sendMessage(chatId, 'Инфа о клубе');
});

bot.onText(/Задать вопрос/, (msg, match) => {
  const chatId = msg.chat.id;
  bot.sendMessage(chatId, 'Задать вопрос!');
});



// setInterval(function(){
//   users.forEach(function callback(value, index, users) {
//     bot.sendMessage(users[index]['chatId'], JSON.stringify(value));
//   });
// },5000);

