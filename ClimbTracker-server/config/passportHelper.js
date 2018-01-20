var JwtStrategy = require('passport-jwt').Strategy;  
var ExtractJwt = require('passport-jwt').ExtractJwt;  
var AuthUser = require('../api/models/AuthUser'); 
var config = require('../config/main');
var passport = require('passport'); 

// Setup work and export for the JWT passport strategy
module.exports = function(passport) {
    var opts = {}; 
    opts.jwtFromRequest = ExtractJwt.fromAuthHeaderWithScheme('jwt'); 
    //opts.jwtFromRequest = ExtractJwt.fromAuthHeaderAsBearerToken();  
    opts.secretOrKey = config.secret; 
    passport.use(new JwtStrategy(opts, function(jwt_payload, next) {
        console.log('inside the jwt strat'); 
        AuthUser.findOne({id: jwt_payload.id}, function(err, authuser) {
            if (err) {
                return next(err, false); 
            }
            if (authuser) {
                next(null, authuser);
            } else {
                next(null, false); 
            }
        });
    }));
}