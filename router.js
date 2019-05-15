
const adminPanel = require('./controllers/AdminController');
const users = require('./controllers/UserController');
const bots = require('./controllers/BotController');

module.exports = (app, bot)=>{
    
    app.get('/admin', adminPanel.show);
    app.get('/users', users.all);
    app.get('/info', adminPanel.info);

    app.post('/send-message', (req, res)=>{
        bots.sendMsgToUser(req, res, bot);
    });
    app.post('/send-message-all', (req, res)=>{
        bots.sendMsgToAllUsers(req, res, bot);
    });
    
    app.post('/change-status', users.changeStatus);
    app.post('/notifications', adminPanel.readNotifications);
};