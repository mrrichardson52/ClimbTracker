var mongoose = require('mongoose'); 
var Schema = mongoose.Schema; 

var ClimbingSessionSchema = new Schema({
    date: {
        type: Date,
        default: Date.now
    },
    problems: [{
        type: Schema.Types.ObjectId,
        ref: 'ClimbingSession',
        default: []
    }],
    user: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true
    }
}); 

module.exports = mongoose.model('ClimbingSession', ClimbingSessionSchema); 