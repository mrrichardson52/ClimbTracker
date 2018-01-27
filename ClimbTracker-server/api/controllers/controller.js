'use strict'

var util = require('util'); 

var mongoose = require('mongoose'); 
var User = require('../models/User'); 
var jwt = require('jsonwebtoken');
var config = require('../../config/main'); 
var Authentication = require('../models/AuthenticationResponse'); 
var Success = require('../models/SuccessResponse'); 
var ClimbingSession = require('../models/ClimbingSession'); 
var Climb = require('../models/Climb'); 
var SessionInfo = require('../models/SessionInfo'); 

// register new users - user is creating an account
module.exports.registration = function(req, res, next) {
    if (!req.body.username || !req.body.password) {
        next(new Error('Missing username and password.')); 
        return; 
    }
    
    var newUser = new User({
        username: req.body.username,
        password: req.body.password
    });
    if (req.body.nickname) {
        newUser.nickname = req.body.nickname;
    }

    // check if the user already exists
    User.find({
        username: req.body.username
    })
    .then((docs) => {
        console.log('Made it here'); 
        if (docs.length) {
            next(new Error('An account with that username already exists.')); 
            return; 
        }

        // save the new user
        var newUser = new User(req.body); 
        newUser.save()
        .then(() => {
            res.model = Success.getResponse(true);
            next(); 
        })
        .catch((err) => {
            next(err); 
        })
    })
    .catch((err) => {
        next(err); 
    }); 
}

// authenticating a user - the user is logging in and we should return a token to the user
module.exports.login = function(req, res, next) {
    var username = {
        username: req.body.username
    }
    User.findOne(username)
    .then(function(user) {
        if (!user) {
            next(new Error('Authentication failed. User not found.')); 
        } else {
            // check if the password matches
            user.comparePassword(req.body.password)
            .then((isMatch) => {
                if (isMatch) {
                    // create token if the password matched
                    var options = {
                        expiresIn: 10080 // seconds
                    }
                    console.log(typeof(user)); 
                    console.log(typeof(config.secret));
                    console.log(typeof(options)); 
                    var token = jwt.sign(JSON.parse(JSON.stringify({id: user._id})), config.secret, options); 
                    res.model = Authentication.getResponse('JWT ' + token); 
                    next(); 
                } else {
                    next(new Error('Authentication failed. Passwords did not match.')); 
                }
            })
            .catch((err) => {
                next(err); 
            }); 
        }
    })
    .catch((err) => {
        next(err); 
    }); 
}

module.exports.createSession = function(req, res, next) {
    if (!req.userID) {
        next(new Error('User not authorized.')); 
        return; 
    }
    if (!req.body.date || !req.body.climbs) {
        next(new Error('Missing required fields in body of request.'));
        return; 
    }

    // save off the climbs
    saveClimbs(req.body)
    .then((climbIds) => {

    })

    var climbs = req.body.climbs; 
    climbs.forEach(function(climb) {
        var newClimb = Climb(climb); 
        newClimb.save()
        .then()
    }, this);

    // save off the session info



    console.log(util.inspect(req.body, false, null)); 
    var climbingSession = new ClimbingSession(req.body); 
    console.log(util.inspect(climbingSession, false, null)); 
    next(); 
}

/**
 * Save the climbs
 * @param {*} climbs - needs to be an array of climb objects
 * Resolves with array of climb ids to be stored in the climbing session
 */
var saveClimbs = function(climbs) {
    return new Promise(function(resolve, reject) {

    }); 



    return new Promise(function(resolve, reject) {
        var climbIds = []; 
        climbs.forEach(function(climb) {
            var newClimb = Climb(climb); 
            newClimb.save()
            .then((climb) => {
                climbIds.push(climb._id); 
            })
            .catch((err) => {
                reject(err); 
            }); 
        });
        resolve(climbIds); 
    }); 
}

function getSave

module.exports.getSessions = function(req, res, next) {
    
}

module.exports.updateSession = function(req, res, next) {
    
}

