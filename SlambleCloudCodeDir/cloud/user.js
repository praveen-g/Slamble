// Provides endpoints for user signup and 

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
  
    // https:/api.parse.com/1/functions/getLeaders
    var leaderBoardArr = ["Claire Opila: 30", "nelson olivera: 15", "Rodrigo Garcia: 12", "Thomas Opila: 10", "Zaid Haque: 9",  "Praveen Gupta: 8", "David Taylor: 6", "John Johns: 4 ", "Ronald Regan: 3", "Tove Lo: 3"];
    res.render('leaderboard', {
          leaderBoardArr: leaderBoardArr

        });

  
    
  //   res.render('leaderboard');
  });

  

  app.get('/signup', function(req, res) {
    res.render('signup');
  });

  app.get('/makeBet', function(req, res) {
    res.render('makeBet');
  })
  // Signs up a new user
  app.post('/makeBet', function(req, res) {
    // var user = Parse.User.current();
    var usernameToBet = req.body.usernameToBet;
    var hoursBet = req.body.hoursBet;
    // var better = user.username;
    var better = Parse.User.current().get('username');
    var betterId =Parse.User.current().id;
    // var betterid = user.objectId;
    // Parse.Cloud.run("getUserId", {username: usernameToBet}, {
    //     success: function(userId) {
    //       var sleeperId = userId;
    //       // sleeperIdStr = String(sleeperId);
    //       // ratings should be 4.5
    //     },
    //     error: function(error) {
    //     }
    // });
    var sleeperId = Parse.Cloud.run("getUserId", {username: usernameToBet});
    console.log("sleeperId " + sleeperId);
   
    message = "You have been bet by " + better + " to sleep " + hoursBet + " hours";

    // var sleeperId;
    console.log("username " + better);
    console.log("betterId " + betterId);
    console.log("hoursBet " + hoursBet);
    console.log("usernameToBet " + usernameToBet);

        
        var myBet = Parse.Object.extend("betClass");
        var betObject = new myBet();
        betObject.set('better', better);
        betObject.set('sleeper', usernameToBet);
        betObject.set('betterid', betterId);
        betObject.set('sleeperId', sleeperId);
        betObject.set('betTime', hoursBet);
        betObject.set('betStatus', "0");
        res.render('makeBet');

        betObject.save().then(function() {
          
          Parse.Cloud.run("sendPushNotificationsToSleeper", {sleeperId: sleeperId, message: message});
          alert('New object created with objectId: ' + betObject.id);
          window.alert("Bet Made!");
          // res.success():
        }, function(error) {
          window.alert("Ruh Roh! Failed to Make Bet!");
          alert('Failed to create new object, with error code: ' + error.message);
          res.render('makeBet' , { flash: "Bet Made"});
          res.error(error);
        });
      });

    app.get('/sleep', function(req, res) {
    res.render('sleep');
  })
    app.post('/sleep', function(req, res) {
    // var sleep = Parse.Object.extend("Sleep");
   
    var username = Parse.User.current().get('username');
    var currentUserId = Parse.User.current().id;
    var firstName = Parse.User.current().get('firstName');
    var lastName = Parse.User.current().get('lastName');
    var hoursSlept= parseInt(req.body.hoursSlept);
    console.log("username " + username);
    console.log("userId " + currentUserId);
    console.log("firstName " + firstName);
    console.log("lastName " + lastName);
    console.log("hoursSlept " + hoursSlept);


    // var sleep = Parse.Object.extend("Sleep");
    var mysleep = Parse.Object.extend("Sleep");
    var sleep = new mysleep();
    sleep.set('username', username);
    sleep.set('sleep', hoursSlept);
    sleep.set('userId', currentUserId);
    sleep.set('firstName', firstName);
    sleep.set('lastName', lastName);

    console.log("sleep is" + sleep);
    sleep.save().then(function() {
      res.render('sleep', { flash: "Sleep Entered!"} );
       Parse.Cloud.run("computeOutcomesForSleeper", {sleeperId: currentUserId, message: hoursSlept});
      alert('New object created with objectId: ' + sleep.id);
      }, function(error) {
        alert('Failed to create new object, with error code: ' + error.message);
      });
    });



  return app;
}();


