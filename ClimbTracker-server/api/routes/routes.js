'use strict'

var passport = require('passport'); 
var controller = require('../controllers/controller'); 
var Authorization = require('../../middleware/Authorization'); 

module.exports = function(app) {

    //app.route('/protected').get(passport.authenticate('jwt', {session: false}), controller.loginSuccessful); 

    app.route('/registration').post(controller.registration); 

    app.route('/login').post(controller.login); 

    app.route('/users')
        .post(Authorization.checkUserAuthorization, controller.createSession)
        .get(Authorization.checkUserAuthorization, controller.getSessions)
        .patch(Authorization.checkUserAuthorization, controller.updateSession);

}

