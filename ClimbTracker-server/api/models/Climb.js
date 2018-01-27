var mongoose = require('mongoose');
var Schema = mongoose.Schema; 

var ClimbSchema = new Schema({
    grade: String,
    climbType: String,
    completionType: String
}); 

module.exports = mongoose.model('Climb', ClimbSchema); 