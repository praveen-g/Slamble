// Provides endpoints for user signup and login

module.exports = function(){
  var express = require('express');
  var app = express();

  // Renders the signup page
  app.get('/signup', function(req, res) {
    res.render('signup');
  });

  // Signs up a new user
  app.post('/signup', function(req, res) {
    var username = req.body.username;
    var password = req.body.password;
    var firstName = req.body.firstName;
    var lastName= req.body.lastName;
    var email= req.body.email;
    var phone= req.body.phoneNumber;

    var user = new Parse.User();
    user.set('username', username);
    user.set('password', password);
    user.set('firstName', firstName);
    user.set('lastName', lastName);
    user.set('email', email);
    user.set('phone', phone);
    user.set('points', 0);
    
    user.signUp().then(function(user) {
      res.redirect('/');
    }, function(error) {
      // Show the error message and let the user try again
      res.render('signup', { flash: error.message });
    });
  });

  // Render the login page
  app.get('/login', function(req, res) {
    res.render('login');
  });

  // Logs in the user
  app.post('/login', function(req, res) {
    Parse.User.logIn(req.body.username, req.body.password).then(function(user) {
      res.redirect('/');
    }, function(error) {
      // Show the error message and let the user try again
      res.render('login', { flash: error.message });
    });
  });

  // Logs out the user
  app.post('/logout', function(req, res) {
    Parse.User.logOut();
    res.redirect('/');
  });

  

  app.get('/leaderboard', function(req, res) {
    res.render('leaderboard');
  });

  return app;
}();


