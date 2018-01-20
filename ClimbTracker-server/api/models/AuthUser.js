var mongoose = require('mongoose');  
var bcrypt = require('bcrypt');

// Schema defines how the user data will be stored in MongoDB
var UserSchema = new mongoose.Schema({  
  username: {
    type: String,
    unique: true,
    required: true
  },
  password: {
    type: String,
    required: true
  },
  role: {
    type: String,
    enum: ['Client', 'Manager', 'Admin'],
    default: 'Client'
  }
});

// Saves the user's password hashed (plain text password storage is not good)
UserSchema.pre('save', function (next) {  
  var user = this;
  if (this.isModified('password') || this.isNew) {

    bcrypt.genSalt(10)
        .then((salt) => {
            bcrypt.hash(user.password, salt)
                .then((hash) => {
                    user.password = hash; 
                    next(); 
                })
                .catch((err) => {
                    next(err); 
                });
        }).catch((err) => {
            next(err); 
        }); 

} else {
    return next(); 
}
}); 

UserSchema.methods.comparePassword = function(password) {
    var userPassword = this.password;
    return new Promise(function(resolve, reject) {
        bcrypt.compare(password, userPassword)
            .then((isMatch) => {
                resolve(isMatch); 
            })
            .catch((err) => {
                reject(err); 
            }); 
    });
}

module.exports = mongoose.model('AuthUser', UserSchema);