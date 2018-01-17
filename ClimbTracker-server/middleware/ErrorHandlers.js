module.exports.catchAll = function(err, req, res, next) {
    res.status(500); 
    res.errors.push(err.message); 
    next(); 
}