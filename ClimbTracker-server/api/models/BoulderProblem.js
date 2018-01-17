var mongoose = require('mongoose'); 
var Schema = mongoose.Schema; 

var BoulderProblemSchema = new Schema({
    name: String,
    rating: String, 
    completed: Boolean,
    flashed: Boolean
}); 

module.exports = mongoose.model('BoulderProblem', BoulderProblemSchema); 