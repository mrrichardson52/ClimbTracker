var express = require('express')
var app = express()
var port = process.env.port || 3000
var bodyParser = require('body-parser');
var db = require('./config/db'); // initializes connection to database
var routes = require('./api/routes/routes'); // import the routes
var validateRoutes = require('./middleware/RouteValidation'); 
var errorHandler = require('./middleware/ErrorHandlers'); 
var responseWrapper = require('./middleware/ResponseWrapper'); 
var morgan = require('morgan'); // logs request type (GET, POST, etc), path, and response time to console
var passport = require('passport'); 
var config = require('./config/main'); 
var passportHelper = require('./config/passportHelper'); 
var formatRequestBody = require('./middleware/RequestBodyFormatter'); 

// first, connect to the database
db.connect(config.database); 

// initialize the values that will be wrapped in the response
// this needs to go before anything that uses the values
app.use(responseWrapper.initResponse); 

// use the body-parser middleware to parse body of request
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// format the req.body
// app.use(formatRequestBody); 

// log requests to console
app.use(morgan('dev')); 

// authenticate user with passport
app.use(passportHelper.getAuthUser)

// use the routes
routes(app);  

// check if a route was taken
app.use(validateRoutes); 

// handle errors
app.use(errorHandler.catchAll); 

// wrap the response
app.use(responseWrapper.wrapResponse); 

// start the server
app.listen(port); 
console.log('ClimbTracker server started on port ' + port); 
