var mongoose = require('mongoose');
var Schema = mongoose.Schema; 

var SessionInfoSchema = new Schema({
    energyRatingBefore: Number,
    eneryRatingAfter: Number
});

module.exports = mongoose.model('SessionInfo', SessionInfoSchema); 