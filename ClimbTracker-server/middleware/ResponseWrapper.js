module.exports.wrapResponse = function(req, res) {
    var wrappedJson = { model: res.model }
    if (res.errors.length) {
        wrappedJson.errors = res.errors; 
    }
    res.send(wrappedJson); 
}

// Initialize the variables on the response object that will store the response 
// information as it is obtained. The ResponseWrapper.wrapResponse function 
// will format the response using these objects. 
module.exports.initResponse = function(req, res, next) {
    res.errors = [] // Error messages will be stored in this array
    res.model = {}; // model will contain the json of the model
    next(); 
}