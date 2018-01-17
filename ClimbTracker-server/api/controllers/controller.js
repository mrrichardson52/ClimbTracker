'use strict'

var mongoose = require('mongoose'); 

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
                        name: newUser.name
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





        //     newUser.save(function(err, user) {
        //         if (err) {
        //             res.send(err); 
        //         } else {
        //             res.json({
        //                 success: "true",
        //                 user: user
        //             });
        //         }
        //     }); 
        // })




//     User.find({ name: req.body.name }, function(err, docs) {
//         if (err) {
//             res.send(err);  
//         } else {
//             if (docs.length) {
//                 res.json({ errorDescription: 'User already exists.'}); 
//             } else {
//                 // save the new user
//                 var newUser = new User(req.body);
//                 newUser.save(function(err, user) {
//                     if (err) {
//                         res.send(err); 
//                     } else {
//                         res.json({
//                             success: "true",
//                             user: user
//                         });
//                     }
//                 }); 
//             }
//         }
//     }); 
// }