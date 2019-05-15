// require('dotenv').config()
// const TelegramBot = require('node-telegram-bot-api');
var user = require('./controllers/UserController');
var action = require('./controllers/ActionController');
var admin = require('./controllers/AdminController');

// const bot = new TelegramBot(process.env.TOKEN, {polling: true});
module.exports = (bot, token)=>{

  bot.onText(/\/start/, (msg) => {user.create(msg, bot, token)});
  bot.on('message', (msg) => {user.create(msg, bot, token)});

  bot.onText(/Узнать расписание/, (msg) => {action.schedule(msg, bot)});

  bot.onText(/^О клубе/, (msg) => {action.about(msg, bot)});

  bot.onText(/вопрос/, (msg) => {action.question(msg, bot)});

  //bot.onText(/звонок/, (msg) => {action.call(msg, bot)});

  bot.onText(/\/admin/, (msg) => {admin.entry(msg, bot)});

  bot.onText(/Рассылка/, (msg) => {admin.spam(msg, bot)});

  bot.onText(/\/new_rasp ([\d\D]*)/m, (msg, match) => {admin.changeSchedule(msg, bot, match)});

  bot.onText(/\/new_about ([\d\D]*)/m, (msg, match) => {admin.changeAbout(msg, bot, match)});

  bot.onText(/Изменить расписание/, (msg) =>{admin.changeScheduleBtn(msg, bot)})

  bot.onText(/Изменить "О клубе"/, (msg) =>{admin.changeAboutBtn(msg, bot)})

  // bot.onText(/(.+)/)


  bot.onText(/Заказать звонок/, (msg) => {action.call(msg, bot)});

}