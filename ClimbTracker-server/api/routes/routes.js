'use strict'

var passport = require('passport'); 

module.exports = function(app) {
    // get reference to the controller that implements the methods for the routes
    var controller = require('../controllers/controller'); 

    app.route('/create').post(controller.createUser); 

    app.route('/protected').get(passport.authenticate('jwt', {session: false}), controller.loginSuccessful); 

    app.route('/registration').post(controller.registration); 

    app.route('/authenticate').post(controller.authenticate); 


}

