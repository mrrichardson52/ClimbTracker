var express = require('express');
var bodyParser = require('body-parser');
require('./config/db'); // initialize mongodb connection
var port = 3001;


/* set the bodyParser to parse the urlencoded post data */
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json());

// start the server
app.listen(port); 
console.log('ClimbTracker server started on port ' + port); 