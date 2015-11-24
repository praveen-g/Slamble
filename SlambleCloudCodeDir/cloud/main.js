



Parse.Cloud.define("computeBetOutcomesForSleeper", function (request, response) {
	var sleeperId = request.params.sleeperId,
		hoursSlept = request.params.hoursSlept
		betQuery = new Parse.Query("betClass");

	Parse.Cloud.useMasterKey();

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
				doneSleeps = 0;

			for (i = 0; i < rlen; i++) {
				// TODO: check timestamp and ignore if > 24 hours earlier
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
				if (betterPoints !== 0) {
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
							if (doneBets === rlen && doneSleeps === rlen) {
								response.success("better was last");
								console.log("better was last")
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
					if (doneBets === rlen && doneSleeps === rlen) {
						// response.success("better was last");
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
							if (doneBets === rlen && doneSleeps === rlen) {
								response.success("better was last");
								console.log("better was last");
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
					if (doneBets === rlen && doneSleeps === rlen) {
						console.log("better was last")
						response.success("better was last");
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
// Parse.Cloud.afterSave("message", function(request, response) {
//   // Our "Comment" class has a "text" key with the body of the comment itself
  
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
			// bet.save();
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
  // Set up to modify user data
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


Parse.Cloud.define("getContacts", function(request,response){
 
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




>>>>>>> fd68ac2771d1b01849e616a08ef091dc0ec34a80

