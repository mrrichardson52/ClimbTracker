'use strict'

var mongoose = require('mongoose'); 
var authUser = require('../models/AuthUser'); 
var jwt = require('jsonwebtoken');
var config = require('../../config/main'); 

// initialize the models
var BoulderProblem = mongoose.model('BoulderProblem');
var ClimbingSession = mongoose.model('ClimbingSession');
var User = mongoose.model('User'); 

module.exports.createUser = function(req, res, next) {

    User.find({ name: req.body.name })
        .then((docs) => {
            if (docs.length) {
                console.log('Name already exists - next with the error'); 
                next(new Error('Name already exists')); 
                return ;
            }
            console.log('1'); 
            // save the new user
            var newUser = new User(req.body);
            newUser.save()
                .then(() => {
                    res.model = {
                        name: newUser
                    }
                    next(); 
                    return; 
                })
                .catch((err) => {
                    next(err);  
                }); 
        })
        .catch((err) => {
            console.log('2'); 
            next(err);  
        }); 


}

// register new users
module.exports.registration = function(req, res, next) {
    if (!req.body.username || !req.body.password) {
        next(new Error('Missing username and password.')); 
    } else {
        var newUser = new authUser({
            username: req.body.username,
            password: req.body.password
        });

      // Attempt to save the user
      newUser.save()
        .then(() => {
            res.model = {
                success: "true"
            }
            next();
        })
        .catch((err) => {
            next(err); 
        }); 
    }
}

// indicate successful login
module.exports.loginSuccessful = function(req, res, next) {
    console.log('We in dis biiiitch'); 
    next(); 
}

// authenticate a user
module.exports.authenticate = function(req, res, next) {
    var username = {
        username: req.body.username
    }
    authUser.findOne(username)
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
                            var token = jwt.sign(JSON.parse(JSON.stringify(user)), config.secret, options); 
                            res.model = {
                                token: 'JWT ' + token
                            }
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