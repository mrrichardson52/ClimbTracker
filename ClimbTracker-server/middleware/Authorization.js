module.exports.checkUserAuthorization = function(req, res, next) {
    // At this point, middleware should have been run that sets req.userID 
    if (!req.userID) {
        next(new Error('Unauthorized user.')); 
        return; 
    }
    next(); 
}