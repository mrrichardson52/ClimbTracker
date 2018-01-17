var express = require('express'),
app = express(),
port = process.env.port || 3000,
bodyParser = require('body-parser');
require('./config/db'); // initializes connection to database
var routes = require('./api/routes/routes'); // import the routes
var validateRoutes = require('./middleware/RouteValidation'); 
var errorHandler = require('./middleware/ErrorHandlers'); 
var responseWrapper = require('./middleware/ResponseWrapper'); 

// use the body-parser middleware to parse body of request
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// initialize the values that will be wrapped in the response
app.use(responseWrapper.initResponse); 

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
