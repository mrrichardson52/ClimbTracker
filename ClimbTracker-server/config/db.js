'use strict'

var mongoose = require('mongoose'); 
var dbURI = 'mongodb://localhost/ClimbTracker'; 

// create the mongoose connection
mongoose.Promise = global.Promise;
mongoose.connect(dbURI, { useMongoClient: true }, function(err) {
    if (err) {
        console.log("Error connecting to mongodb."); 
    }
}); 

// require all of the models to make sure they are registered
require('../api/models/BoulderProblem');
require('../api/models/ClimbingSession');
require('../api/models/User'); 