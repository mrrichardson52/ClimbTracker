module.exports = function(req, res, next) {
    // the httpBody of the request is stored in req.body.model
    // For example, if we're receiving a User object with username and password as 
    // properties, then we can access those through req.body.model.username and 
    // req.body.model.username. However, we would like to remove the model piece. 
    // This made things simple and clean on the mobile client. 
    if (req.body.model) {
        req.body = req.body.model; 
    }
    next(); 
}