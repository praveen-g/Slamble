



Parse.Cloud.define("computeBetOutcomesForSleeper", function (request, response) {
	//computest outcomes for the bets where the user who entered sleep was the sleeper
	var sleeperId = request.params.sleeperId,
		hoursSlept = request.params.hoursSlept
		betQuery = new Parse.Query("betClass");

	Parse.Cloud.useMasterKey();

	//queries the bet class for all bets that the user accepted and was a sleeper
	betQuery.equalTo("sleeperId", sleeperId);
	betQuery.equalTo("betStatus", "1");
	betQuery.find({
		success: function (results) {
			var i,
				rlen = results.length,
				bet,
				betTime,
				// hoursSlept,
				betterId,
				userQuery,
				betterPoints,
				sleeperPoints,
				doneBets = 0,
				doneSleeps = 0,
				userPoints = 0;

			for (i = 0; i < rlen; i++) {
				bet = results[i];
				betTime = parseInt(bet.get("betTime"));
				// hoursSlept = parseInt(bet.get("hoursSlept"));
				betterId = bet.get("betterid");

				// calculate how much to increment points per user
				if (betTime < hoursSlept) {
					// sleeper wins
					console.log ("betTime: "+betTime+", hoursSlept: "+hoursSlept+" SLEEPER WINS");
					betterPoints = 0;
					sleeperPoints = 2;
				}
				else if (betTime > hoursSlept) {
					// better wins
					console.log ("betTime: "+betTime+", hoursSlept: "+hoursSlept+" BETTER WINS");
					betterPoints = 2;
					sleeperPoints = -1;
				}
				else {
					// tie
					console.log ("betTime: "+betTime+", hoursSlept: "+hoursSlept+" TIE I HATE THIS");
					betterPoints = 1;
					sleeperPoints = 1;
				}

				//update bet object points for sleeper and better
				bet.set("betterPoints", betterPoints.toString());
				bet.set("sleeperPoints", sleeperPoints.toString());
				bet.set("betStatus", "3");
				bet.set("hoursSlept", hoursSlept);
				bet.save();

				// update each user's total points
				if (betterPoints !== 0) 
				{
					userQuery = new Parse.Query(Parse.User);
					userQuery.get(betterId, {
						success: function (user) {
							console.log("got better user");
							if (user.get("points") === undefined) {
								console.log("resetting better points");
								user.set("points", 0);
							}
							user.increment("points", betterPoints);
							console.log("incrementing user points" + betterPoints.toString());
							user.save();
							doneBets++;

							//if all bets have been computed for the user as sleeper, return the sleepers current points
							if (doneBets === rlen && doneSleeps === rlen) {
								userQuery2 = new Parse.Query(Parse.User);
								userQuery2.get(sleeperId, {
									success: function (user) {
										console.log("got sleeper user");
										userPoints = user.get("points");
										console.log("better was last, user points are: " + points);
										response.success(userPoints);
									},
									error: function (user, error) {
										console.log(user);
										console.log(error);
									}	
								});
							}
						},
						error: function (user, error) {
							console.log(user);
							console.log(error);
						}
					});
				}
				else {
					doneBets++;

					//if all bets have been computed for the user as sleeper, return the sleepers current points
					if (doneBets === rlen && doneSleeps === rlen) {
						userQuery = new Parse.Query(Parse.User);
						userQuery.get(sleeperId, {
							success: function (user) {
								console.log("got sleeper user");
								userPoints = user.get("points");
								console.log("better was last, user points are: " + points);
								response.success(userPoints);
							},
							error: function (user, error) {
								console.log(user);
								console.log(error);
							}	
						});
					}
					console.log("i hate my life");
				}

				if (sleeperPoints !== 0){
					userQuery = new Parse.Query(Parse.User);
					userQuery.get(sleeperId, {
						success: function (user) {
							console.log("got sleeper user");
							if (user.get("points") === undefined){
								console.log("resetting sleeper points");
								user.set("points", 0);
							}
							user.increment("points", sleeperPoints);
							console.log("incrementing user points" + sleeperPoints.toString());
							user.save();
							doneSleeps++;

							//if all bets have been computed for the user as sleeper, return the sleepers current points 
							if (doneBets === rlen && doneSleeps === rlen) {
								userPoints = user.get("points");
								console.log("slepper was last, user points are: " + userPoints);
								response.success(userPoints);
							}
						},
						error: function (user, error) {
							console.log(user);
							console.log(error);
						}
					});
				}
				else {
					doneSleeps++;

					//if all bets have been computed for the user as sleeper, return the users current points
					if (doneBets === rlen && doneSleeps === rlen){
						userQuery = new Parse.Query(Parse.User);
						userQuery.get(sleeperId, {
							success: function (user) {
								console.log("got sleeper user");
								userPoints = user.get("points");
								console.log("sleeper was last, points are: " + points);
								response.success(userPoints);
							},
							error: function (user, error) {
								console.log(user);
								console.log(error);
							}	
						});
					}
					console.log("i hate my life 2");
				}
			}
			// response.success("success");
		},
		error: function(error) {
			console.log("Error: " + error.code + " " + error.message);
			response.error("oh no");
		}
	});

});

Parse.Cloud.define("sendPushNotificationsToSleeper", function (request, response){
	//sends a push notification to the sleeper after a bet has been iniated against them
	//input: the id of the sleeper to send the push notification to
	//input: a string message coming from iOS that includes who the better was, and the amount of time user was bet
  
// var data = request.params.data;
	var sleeperId = request.params.sleeperId,
		pushQuery = new Parse.Query(Parse.Installation),
		message = request.params.message;

	console.log("sleeperId is" + sleeperId);
	console.log("message is" + message);


	Parse.Cloud.useMasterKey();

	// var pushQuery = new Parse.Query(Parse.Installation);
	// pushQuery.equalTo('deviceType', 'ios');

	pushQuery.equalTo("installationUserId", sleeperId);

	Parse.Push.send({
		where: pushQuery, // Set our Installation query
		data: {
		alert: message,
		// badge: "Increment",
		title: "New Bet!",
		}
	}, {
		success: function() {
			// Push was successful
			console.log("push was successful");
			response.success("push was a success");
		},
		error: function(error) {
			throw "Got an error" + error.code + " : " + error.message;
			console.log("push caused an error");
			response.error("push failed")
		}
	});
	
});


Parse.Cloud.define("sendPushNotificationsToBetter", function (request, response){
	//sends a push notification to the person who initiated a bet when a bet has been accepted or declined by the user
	//also updates the corresponding bet to the bet status of 1 or 2. 1 is accepted, 2 is declined. 
	//input : the id of the better who initiated the bet, the id of the bet object to update 
	//input: the message saying whether the sleeper accepted or declined the bet
	var betterID = request.params.betterID,
		objectID = request.params.objectID,
		message = request.params.message,
		betStatus = request.params.betStatus
		pushQuery = new Parse.Query(Parse.Installation),
		betQuery = new Parse.Query("betClass");


	console.log("betterID is " + betterID);
	console.log("objectID " + objectID);
	console.log("message is " + message);
	console.log("betStatus " + betStatus);

	// pushQuery.matchesKeyInQuery(username, betterName, filterQuery);

	Parse.Cloud.useMasterKey();

	// var filterQuery = new Parse.Query(Parse.betRequest);
	// filterQuery.equalTo('betStatus', "0" );

	pushQuery.equalTo("installationUserId", betterID);

	//sends push notification to the better with the message of whether or not bet was accepted or declined
	Parse.Push.send({
		where: pushQuery, // Set our Installation query
		data: {
		alert: message,
		// badge: "Increment",
		title: "Updated Bet!",
		}
	}, {
		success: function() {
			// Push was successful
			console.log("push was successful");
			response.success("push was a success");
		},
		error: function(error) {
			throw "Got an error" + error.code + " : " + error.message;
			console.log("push caused an error");
			response.error("oh no");
			// response.error("push failed")
		}
	});

	//initiates a query on the bet class for the bet object corresponding to the bet objectid that the user accepted or declined
	betQuery.equalTo("objectId", objectID);
	betQuery.find({

		success: function (results) {
			var results,
			betStatusOld,
			betStatusCurrent,
			bet;

			console.log("results is " + results);

			bet = results[0];
			console.log("bet is" + bet);
			betStatusOld = bet.get("betStatus");
			console.log("betStatusOld" + betStatusOld);
			bet.set("betStatus", betStatus);
			//sets the  bet to 0 or 1 depending on whether the sleeper accepted or declined
			// saves the bet with the new status
			bet.save(null, 
            {
                success:function ()
                {
                    response.success("updated status!");
                },
                error:function (error)
                {
                    throw "Got an error" + error.code + " : " + error.message;
                    response.error("Failed to save bet with status, Error=" + error.message);
                }
            });

		},
		error: function(error) {
			throw "Got an error " + error.code + " : " + error.message;
		}

		 	
	});
});


Parse.Cloud.job("sendPushReminderMorning", function(request, status) {
	//sends a push notification to all users to enter the amount they slept

	// pushQuery.matchesKeyInQuery(username, betterName, filterQuery);

	Parse.Cloud.useMasterKey();

	// var filterQuery = new Parse.Query(Parse.betRequest);
	// filterQuery.equalTo('betStatus', "0" );
	var pushQuery = new Parse.Query(Parse.Installation);
	pushQuery.equalTo("deviceType", "ios");

	Parse.Push.send({
		where: pushQuery, // Set our Installation query
		data: {
		alert: "Morning Sunshine! How much did you sleep last night?",
		// badge: "Increment",
		title: "Morning Sunshine!",
		}
	}, {
		success: function() {
			// Push was successful
			console.log("push was successful");
			status.success("push was a success");
		},
		error: function(error) {
			throw "Got an error" + error.code + " : " + error.message;
			console.log("push caused an error");
			status.error("failed to send push");
			// response.error("push failed")
		}
	});
	// response.success("push was successful");

  // Set up to modify user data

});

Parse.Cloud.job("sendPushReminderEvening", function(request, status) {
  // sends a push notification to all users to remind them to get enough sleep to win their bets
  Parse.Cloud.useMasterKey();
  var pushQuery = new Parse.Query(Parse.Installation);
  pushQuery.equalTo("deviceType", "ios");

	Parse.Push.send({
		where: pushQuery, // Set our Installation query
		data: {
		alert: "It's Getting Late! Make sure you sleep enough to win your bets!",
		// badge: "Increment",
		title: "It's Getting Late!",
		}
	}, {
		success: function() {
			// Push was successful
			console.log("push was successful");
			status.success("push was a success");
		},
		error: function(error) {
			throw "Got an error" + error.code + " : " + error.message;
			console.log("push caused an error");
			status.error("push failed");
			// response.error("push failed")
		}
	});
	// response.success("push was successful");

});

//for today/s date
Date.prototype.today = function () { 
    return ((this.getDate() < 10)?"0":"") + this.getDate() +"/"+(((this.getMonth()+1) < 10)?"0":"") + (this.getMonth()+1) +"/"+ this.getFullYear();
}

// For the time now
Date.prototype.timeNow = function () {
     return ((this.getHours() < 10)?"0":"") + this.getHours() +":"+ ((this.getMinutes() < 10)?"0":"") + this.getMinutes() +":"+ ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
}

Parse.Cloud.job("expireBets0", function(request, status) {
	//this function sets all bets that have been initiated, but not accepted or declined on to a status of 4 (expired)
	//gets the current date
	var newDate = new Date();
	var datetime = "LastSync: " + newDate.today() + " @ " + newDate.timeNow();
	//logs the current date
	console.log("date is: " + newDate);
	console.log("dateTime is: " + datetime);
	Parse.Cloud.useMasterKey();

	// does a betquery for all bets that have status of 0 (i.e. initiated but not acted on)
  	var betQuery = new Parse.Query("betClass")
  	betQuery.equalTo("betStatus", "0");
  	betQuery.find({

		success: function (results) {
			var results,
			rlen = results.length,
				betStatusOld,
				myDate,
				betExpireDateTime,
				betCreatedAtDate;

			console.log("results is " + results);

			for (i = 0; i < rlen; i++){
				bet = results[i];
				console.log("bet is" + bet);
				//gets the date the bet was created
				betCreatedAtDate = bet.get("createdAt");
				console.log("betCreatedAtTime is " + betCreatedAtDate);

				// sets the expiration date of the bet to 24 hours + the date it was created
				betExpireDateTime = new Date(betCreatedAtDate); // your date object
				console.log("betExpireDateTime before adding 24 is " + betExpireDateTime);
				betExpireDateTime.setHours(betExpireDateTime.getHours() + 24);
  				console.log("betExpireDateTime after adding 24 is " + betExpireDateTime);
  
  // if the bet expiration date is older than the current date/time, set the bet status to 4 (i.e. expired)
				if (betExpireDateTime < newDate) {
					betStatusOld = bet.get("betStatus");
					console.log("betStatusOld" + betStatusOld);
					bet.set("betStatus", "4");
					bet.save(null, {
		                success:function ()
		                {
		                    console.log("saved object")
		                },
		                error:function (error)
		                {
		                    throw "Got an error" + error.code + " : " + error.message;
		                    // response.error("Failed to save bet with status, Error=" + error.message);
		                }
	            	});
				}	
			

			}
			status.success("expired Bet!");
		},
		error: function(error) {
			// throw "Got an error " + error.code + " : " + error.message;
			status.error("error" + error);
		}

		 	
	});
  	
  

});

Parse.Cloud.job("expireBets1", function(request, status) {
//this function sets all bets that have been accepted, but have not been completed within 24 hours
// of being accepted to a status of 4 (expired)

	//gets the current date
	var newDate = new Date();
	var datetime = "LastSync: " + newDate.today() + " @ " + newDate.timeNow();
	//logs the current date
	console.log("date is: " + newDate);
	console.log("dateTime is: " + datetime);
	Parse.Cloud.useMasterKey();

	// does a betquery for all bets that have status of 1 (i.e. accepted)
  	var betQuery = new Parse.Query("betClass")
  	betQuery.equalTo("betStatus", "1");
  	betQuery.find({

		success: function (results) {
			var results,
			rlen = results.length,
				betStatusOld,
				myDate,
				betExpireDateTime,
				betUpdatedAtDate;

			console.log("results is " + results);

			for (i = 0; i < rlen; i++){
				bet = results[i];
				console.log("bet is" + bet);
				//gets the date the bet was created
				betUpdatedAtDate = bet.get("updatedAt");
				console.log("betupDatedAtTime is " + betUpdatedAtDate);

				// sets the expiration date of the bet to 24 hours + the date it was last updated
				betExpireDateTime = new Date(betUpdatedAtDate); // your date object
				console.log("betExpireDateTime before adding 24 is " + betExpireDateTime);
				betExpireDateTime.setHours(betExpireDateTime.getHours() + 24);
  				console.log("betExpireDateTime after adding 24 is " + betExpireDateTime);
  
  // if the bet expiration date is older than the current date/time, set the bet status to 4 (i.e. expired)
				if (betExpireDateTime < newDate) {
					betStatusOld = bet.get("betStatus");
					console.log("betStatusOld" + betStatusOld);
					bet.set("betStatus", "4");
					bet.save(null, {
		                success:function ()
		                {
		                    console.log("saved object")
		                },
		                error:function (error)
		                {
		                    throw "Got an error" + error.code + " : " + error.message;
		                    // response.error("Failed to save bet with status, Error=" + error.message);
		                }
	            	});
				}	
			

			}
			status.success("expired Bet!");
		},
		error: function(error) {
			// throw "Got an error " + error.code + " : " + error.message;
			status.error("error" + error);
		}

		 	
	});
  	
  

});


Parse.Cloud.define("getContacts", function(request,response){
	//returns a list of contacts that are in your contacts addresss book
 
    var query = new Parse.Query(Parse.User);
          query.containedIn("phone", request.params.phoneNumbers);
          query.find().then(function(result) {
            var i
            var contacts=[]
            for (i=0;i <result.length ; i++) {
                contacts.push(result[i].get("firstName"))
                contacts.push(result[i].get("lastName"))
                contacts.push(result[i].get("username"))
                console.log(contacts)
                 
            }
            console.log("yo")
            console.log(contacts)
            response.success(result);
          }, function (error) {
             
            response.error(error);
        });
 
});
 
Parse.Cloud.define("get", function(request,response){
 
    var query = new Parse.Query(Parse.User);
          query.containedIn("phone", request.params.phoneNumbers);
          query.find().then(function(result) {
            var i
            var contacts=[]
             
             for (i=0;i <result.length ; i++) {
                contacts.push(result[i].get("firstName"))
                contacts.push(result[i].get("lastName"))
                contacts.push(result[i].get("username"))
                 
                 
            }
            console.log("yo")
            console.log(contacts)
            result.set("Contacts",contacts)
            result.save()
            response.success(result);
           
          }, function (error) {
             
            response.error(error);
        });
 
});

require('cloud/app.js');

var resizeImageKey = require('cloud/resize-image-key');
var ImageMetadata = Parse.Object.extend("ImageMetadata");

var NORMAL_WIDTH = 612;
var SMALL_WIDTH = 110;

// Resize image into various sizes before saving
Parse.Cloud.beforeSave("Image", function(req, res) {
  var original = req.object.get('sizeOriginal');

  Parse.Promise.as().then(function() {
    // Create an image metadata object on creation
    if (req.object.isNew()) {
      var im = new ImageMetadata;
      im.set("views", 0);
      return im.save();    
    }
  }).then(function(im) {
    // Set the metadata object relationship
    if (im) {
      req.object.set("imageMetadata", im);
    }
    
    if (!original) {
      return Parse.Promise.error("No original sized image file set.");
    }

    if (!req.object.dirty("sizeOriginal")) {
      // The original isn't being modified.
      return Parse.Promise.as();
    }

    // Don't set blank titles
    if (req.object.get("title").length === 0) {
      req.object.unset("title");
    }

    // Resize to a normal "show" page image size  
    return resizeImageKey({
      object: req.object,
      fromKey: "sizeOriginal",
      toKey: "sizeNormal",
      width: NORMAL_WIDTH
    })
  }).then(function() {
    // Resize to a smaller size for thumbnails
    return resizeImageKey({
      object: req.object,
      fromKey: "sizeOriginal",
      toKey: "sizeSmall",
      width: SMALL_WIDTH,
      crop: true
    });
  }).then(function(result) {
    res.success();
  }, function(error) {
    res.error(error);
  });
});

// Does all the work to update metadata about an image upon a view
Parse.Cloud.define("viewImage", function(request, response) {
  // Use the master key to prevent clients from tampering with view count
  Parse.Cloud.useMasterKey();
  var object = new ImageMetadata;
  object.id = request.params.metadataId;
  
  object.increment("views");
  object.save().then(function() {
    response.success();
  }, function(error) {
    response.error(error);
  });
});




