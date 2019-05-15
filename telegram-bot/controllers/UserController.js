const db = require('../../config/Db').db;
require('dotenv').config();

exports.create = (msg, bot, token) => {

  var user_profile = bot.getUserProfilePhotos(msg.from.id);


  user_profile.then(function (res) {
    console.log('УХУХУХ', res);
      var file_id = res.photos[0][0].file_id;
      var file = bot.getFile(file_id);
      file.then(function (result) {
          var file_path = result.file_path;
          var avatar = `https://api.telegram.org/file/bot${token}/${file_path}`

          let newUser = [parseInt(msg.chat.id), msg.from.first_name, msg.from.last_name, msg.from.username, avatar]; 
          //console.log(msg);
          db.func('create_user', newUser);

      })
      
    })
    .catch((error)=>{
      let newUser = [parseInt(msg.chat.id), msg.from.first_name, msg.from.last_name, msg.from.username]; 
      db.func('create_user', newUser);
    })



    

    const chatId = msg.chat.id;
    bot.sendMessage(chatId, 'Выберите действие', {
      reply_markup: {
      keyboard:[
          [
            {text: 'Узнать расписание'},
          ],
          [
            {text: 'О клубе'},
            {text: 'Задать вопрос'},
            {text: 'Заказать звонок'}
          ]
      ],
      resize_keyboard: true
      }
    });
    
}







