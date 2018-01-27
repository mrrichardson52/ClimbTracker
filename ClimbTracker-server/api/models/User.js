var mongoose = require('mongoose'); 
var Schema = mongoose.Schema; 
var bcrypt = require('bcrypt');

var UserSchema = new Schema({

    username: {
        type: String,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    nickname: String
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

  UserSchema.methods.getApiModel = function() {
      var returnModel = {
          username: this.username,
      }
      if (this.nickname) {
          returnModel.nickname = this.nickname; 
      }
      return returnModel; 
  }

module.exports = mongoose.model('User', UserSchema); 