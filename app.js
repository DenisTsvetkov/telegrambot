require('dotenv').config();

const express    = require('express');
const bodyParser = require('body-parser');
const expressHbs = require("express-handlebars");
// const favicon = require('express-favicon');

const TelegramBot = require('node-telegram-bot-api');
const bot = new TelegramBot(process.env.TOKEN, {polling: true});


require(__dirname+'/telegram-bot/bot')(bot, process.env.TOKEN);

const app = express();

// app.use(favicon(__dirname + '/public/img/favicon.ico'));

// For Handlebars
app.engine("hbs", expressHbs(
    {
        layoutsDir: "views/layouts", 
        defaultLayout: "layout",
        extname: "hbs",
        helpers: {
            procent: function(array, index){
                const reducer = (accumulator, currentValue) => accumulator + currentValue;
                var sum = array.reduce(reducer);
                return ((array[index]*100)/sum).toFixed(2);
            },
            ifCond: function(v1, v2, options) {
                if(v1 == v2) {
                  return options.fn(this);
                }
                return options.inverse(this);
            },
            not_equals: function(v1, v2, options) {
                if(v1 != v2) {
                  return options.fn(this);
                }
                return options.inverse(this);
            },
            count_votes: function(array, index){
                return array[index];
            },
        }
    }
))
app.set("view engine", "hbs");


app.use('/', express.static(__dirname+'/public/'));

//For BodyParser
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
  extended: true
}));


require(__dirname+'/router')(app, bot);




app.listen(8080, function(){
    console.log('Express server listening on port 8080');
});