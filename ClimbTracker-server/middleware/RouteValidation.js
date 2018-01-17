// Make sure to use this function after using the routes
var validateRoute = function(req, res, next) {
    console.log('validate Routes'); 
    if (!req.route) {
        // if the route doesn't exist
        next(Error('Page not found.')); 
    }
    next(); 
}

module.exports = validateRoute; 