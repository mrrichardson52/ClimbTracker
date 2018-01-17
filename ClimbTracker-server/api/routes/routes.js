'use strict'

module.exports = function(app) {
    // get reference to the controller that implements the methods for the routes
    var controller = require('../controllers/controller'); 

    app.route('/create').post(controller.createUser); 
}