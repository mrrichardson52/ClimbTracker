var JwtStrategy = require('passport-jwt').Strategy;  
var ExtractJwt = require('passport-jwt').ExtractJwt;  
var JWT = require('jsonwebtoken'); 
var config = require('../config/main');
var passport = require('passport'); 
var User = require('../api/models/User'); 
var config = require('../config/main'); 

// // Setup work and export for the JWT passport strategy
// module.exports = function(passport) {
//     var opts = {}; 
//     opts.jwtFromRequest = ExtractJwt.fromAuthHeaderWithScheme('jwt'); 
//     //opts.jwtFromRequest = ExtractJwt.fromAuthHeaderAsBearerToken();  
//     opts.secretOrKey = config.secret; 
//     passport.use(new JwtStrategy(opts, function(jwt_payload, next) {
//         console.log('inside the jwt strat with id: ' + jwt_payload.id); 
//         User.findOne({id: jwt_payload}, function(err, user) {
//             if (err) {
//                 return next(err, false); 
//             }
//             if (user) {
//                 next(null, user);
//             } else {
//                 next(null, false); 
//             }
//         });
//     }));
// }

module.exports.getAuthUser = function(req, res, next) {
    if (req.headers && req.headers.authorization && req.headers.authorization.split(' ')[0] === 'JWT') {
        JWT.verify(req.headers.authorization.split(' ')[1], config.secret, function(err, decode) {
            if (err || !decode) {
                //console.log('Error verifying user token');
                req.userID = undefined; 
                next(); 
                return; 
            }
            console.log("Successfully verified. Now to check if user exists."); 
            User.findOne({_id: decode.id})
            .then((user) => {
                console.log(user); 
                if (user && user.id) {
                    console.log('User exists. Setting rer.userID'); 
                    req.userID = user.id; 
                    next();
                    return; 
                }
                if (!user) {
                    console.log("User does not exist.");
                }
                if (!user.id) {
                    console.log("User id does not exist."); 
                }
                req.userID = undefined;
                next(); 
            })
            .catch((err) => {
                console.log('Error finding user. Setting req.userID to undefined'); 
                req.userID = undefined;
                next(); 
            });
        });
    } else {
        console.log('JWT token not in authorization field'); 
        req.userID = undefined; 
        next(); 
    }

}