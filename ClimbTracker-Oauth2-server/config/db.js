var mongoose = require('mongoose'); 
var dbURI = 'mongodb://localhost/ClimbTracker-OAuth2'; 

// create the mongoose connection
mongoose.Promise = global.Promise;
mongoose.connect(dbURI, { useMongoClient: true }, function(err) {
    if (err) {
        console.log("Error connecting to mongodb."); 
    }
}); 

