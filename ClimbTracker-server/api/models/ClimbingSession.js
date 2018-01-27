var mongoose = require('mongoose'); 
var Schema = mongoose.Schema; 
var Climb = require('../models/Climb'); 

var ClimbingSessionSchema = new Schema({
    user: {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    date: {
        type: Date,
        default: Date.now
    },
    climbs: {
        type: [Climb.Schema],
        default: []
    },
    info: {
        type: Schema.Types.ObjectId,
        ref: 'SessionInfo',
    }
}); 

module.exports = mongoose.model('ClimbingSession', ClimbingSessionSchema); 