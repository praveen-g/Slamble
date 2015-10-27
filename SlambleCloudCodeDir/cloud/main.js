
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
// Parse.Cloud.define("hello", function(request, response) {
//   response.success("Hello world!");
// });


// Parse.Cloud.define("bet",function(request,response){
// 	var objectId = request.params.objectId;

// 	var query = new Parse.Query("betClass");
// 	query.get(objectId,{
// 		success:function(bet){
// 			response.success(bet.get("better")+" "+"has bet"+bet.get("sleeper")+ " " +"to sleep at least"+ " " + bet.get("betTime"));
// 		},
// 		error:function(error){
// 			response.error(error.message);
// 		}
// 	});
// });

	
// Parse.Cloud.define("winner", function(request,response){
// 	var objectId=request.params.objectId;
// 	var query=new Parse.Query("betClass");
// 	query.equalTo("objectId",objectId);
// 	query.first({

// 		success:function(bet){
// 			//console.log("ok")
// 			var points=parseInt(bet.get("points"));
// 			if (parseInt(bet.get("betTime")) < parseInt(bet.get("hoursSlept"))){
// 				points ++;

// 			}

// 			else if (parseInt(bet.get("betTime")) === parseInt(bet.get("hoursSlept"))){
// 				points +=0;

// 			}

// 			else {
// 				points --;
// 			}

// 			// else if (parseInt(query.betTime) === parseInt(query.hoursSlept)){
// 			// 	points=0
// 			// }
// 			betPoints=points.toString();


// 			bet.set("points",betPoints);
// 			bet.save();
// 			response.success("Success Message");

// 		},
// 		error:function(error){
// 			response.error("Error Message");
// 		}

// 	});


// });

// Parse.Cloud.define("betWinner", function(request,response){
// 	var objectId=request.params.objectId;
// 	var query=new Parse.Query("betClass");
// 	query.equalTo("objectId",objectId);
// 	query.first({

// 		success:function(bet){
// 			//console.log("ok")
// 			if(bet.get("betterPoints") !== undefined){
// 				var betterPoints=parseInt(bet.get("betterPoints"));
// 			}
// 			else{
// 				var betterPoints=0;
// 			}
			
// 			if(bet.get("sleeperPoints") !== undefined){
// 				var sleeperPoints=parseInt(bet.get("sleeperPoints"));
// 			}
// 			else{
// 				var sleeperPoints=0;
// 			}
// 			if (parseInt(bet.get("betTime")) < parseInt(bet.get("hoursSlept"))){
// 				betterPoints ++;
// 				sleeperPoints ++;

// 			}

// 			else if (parseInt(bet.get("betTime")) === parseInt(bet.get("hoursSlept"))){
// 				betterPoints ++;
// 				sleeperPoints +=0;

// 			}

// 			else {
// 				betterPoints +=2;
// 				sleeperPoints --;
// 			}

// 			// else if (parseInt(query.betTime) === parseInt(query.hoursSlept)){
// 			// 	points=0
// 			// }
// 			betterBetPoints=betterPoints.toString();
// 			sleeperBetPoints=sleeperPoints.toString();

// 			bet.set("betterPoints",betterBetPoints);
// 			bet.set("sleeperPoints",sleeperBetPoints);
// 			bet.save();
// 			response.success("Success Message");

// 		},
// 		error:function(error){
// 			response.error("Error Message");
// 		}

// 	});


// });


// Parse.Cloud.define("updateUserSleeperPoints", function(request,response){
// 	var currentUser=request.params.currentUsername;
// 	var query=new Parse.Query("betClass");
// 	query.equalTo("sleeper",currentUser);
// 	query.find({

// 		success:function(results){
// 			//console.log("ok")
// 			var sum=0;
// 			for( var i=0; i< results.length;i++){
// 				sum +=parseInt(results[i].get("sleeperPoints"));
// 			}
// 			userSleeperPoints=sum.toString();
// 			console.log("sdfafervtve");
// 			console.log(userSleeperPoints);
// 			results.save();
// 			console.log(userSleeperPoints);
// 			response.success("Success Message");

// 		},
// 		error:function(error){
// 			response.error("Error Message");
// 		}

// 	});


// });

// Parse.Cloud.define("updateUserBetterPoints", function(request,response){
// 	var currentUser=request.params.currentUsername;
// 	var query=new Parse.Query("betClass");
// 	query.equalTo("better",currentUser);
// 	query.find({

// 		success:function(results){
// 			//console.log("ok")
// 			var sum2=0;
// 			for( var i=0; i< results.length;i++){
// 				sum2 +=parseInt(results[i].get("betterPoints"));
// 			}
// 			userBetterPoints=sum.toString();
// 			results.save();
// 			response.success("Success Message");

// 		},
// 		error:function(error){
// 			response.error("Error Message");
// 		}

// 	});


// });

// Parse.Cloud.define("updateUserPoints", function(request,response){
// 	var currentUsername=request.params.currentUsername;
// 	var pointsBetter=updateUserBetterPoints(currentUsername);
// 	var pointsSleeper=updateUserSleeperPoints(currentUsername);
// 	intPointsBetter=parseInt(pointsBetter);
// 	intPointsSleeper=parseInt(pointsSleeper);
// 	var points= intPointsSleeper + intPointsBetter;
	
// 	var query=new Parse.Query(Parse.User);
// 	query.equalTo("username",currentUser);
// 	query.first({

// 		success:function(results){
// 			//console.log("ok")

// 			if(results.get("points") !== undefined){
// 				var currentPoints=parseInt(results.get("points"));
// 			}
// 			else{
// 				var currentPoints=0;
// 			}

// 			currentPoints += points;
// 			userCurrentPoints=currentPoints.toString();
// 			results.save();
// 			response.success("Success Message");

// 		},
// 		error:function(error){
// 			response.error("Error Message");
// 		}

// 	});


// });

Parse.Cloud.define("computeBetOutcomesForSleeper", function (request, response) {
	var sleeperId = request.params.sleeperId,
		betQuery = new Parse.Query("betClass");

	Parse.Cloud.useMasterKey();

	betQuery.equalTo("sleeperId", sleeperId);
	betQuery.find({
		success: function (results) {
			var i,
				rlen = results.length,
				bet,
				betTime,
				hoursSlept,
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
				hoursSlept = parseInt(bet.get("hoursSlept"));
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
							user.save();
							doneBets++;
							if (doneBets === rlen && doneSleeps === rlen) {
								response.success("better was last");
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
						response.success("better was last");
					}
					console.log("i hate my life");
				}

				if (sleeperPoints !== 0) {
					userQuery = new Parse.Query(Parse.User);
					userQuery.get(sleeperId, {
						success: function (user) {
							console.log("got sleeper user");
							if (user.get("points") === undefined) {
								console.log("resetting sleeper points");
								user.set("points", 0);
							}
							user.increment("points", sleeperPoints);
							user.save();
							doneSleeps++;
							if (doneBets === rlen && doneSleeps === rlen) {
								response.success("better was last");
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
						response.success("better was last");
					}
					console.log("i hate my life 2");
				}
			}
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
	pushQuery.equalTo('installationUserId', 'sleeperId');


	Parse.Push.send({
		where: pushQuery, // Set our Installation query
		data: {
		alert: message
		}
	}, {
		success: function() {
			// Push was successful
			console.log("push was successful");
			response.success("push was a success");
		},
		error: function(error) {
			throw "Got an error " + error.code + " : " + error.message;
			console.log("push caused an error");
			response.error("push failed")
		}
	});
});

// Parse.Cloud.define("betWinner2", function(request,response){
// 	var objectId=request.params.objectId;
// 	var query=new Parse.Query("betClass");

// console.log("--= Function STart =--");
// console.log("Object ID: "+ objectId);

// 	query.equalTo("objectId",objectId);

//  	query.count().then(function(cnt){
// 	   console.log("THE NUMBER OF OBJECTS FOUND IS: " +cnt);

//  	}, function(){
//  		console.log("Fail");
//  		console.log(arguments);
//  	}).always(function(){
//  		console.log('Count Happened');
//  	});


// 	query.first({

// 		success:function(bet){
// 			//console.log("ok")
// 			var points=parseInt(bet.get("points"));
// 			var better=bet.get("better");
// 			var sleeper=bet.get("sleeper");
// 			console.log('start!!!');

// 			console.log(better + " bet "+sleeper+" will sleep "+bet.get("betTime"));


// 			if (parseInt(bet.get("betTime")) < parseInt(bet.get("hoursSlept"))){
// 				console.log('sleeper wins');
// 				var queryUser= new Parse.Query("User");
// 				console.log("created query "+queryUser);
// 				queryUser.equalTo("username",better);
// 				console.log("added constraint to "+JSON.stringify(queryUser.toJSON()));
// 				queryUser.first(
// 					/*success:function(user){
// 						console.log("Got user obj");
// 						var userPoints=parseInt(user.get("points"));
// 						userPoints ++;
// 						userBetPoints=userPoints.toString();
// 						console.log("New points = "+userBetPoints);
// 						user.set("points",userBetPoints);
// 						console.log("111111111111");
// 						user.save();
// 						response.success("Success Message");
// 					},
// 					error:function(error){
// 						console.log("got error "+error);
// 						response.error("Error Message");
// 					}
// 				}*/
// 				).always(function(){
// console.log('ALWASY');
// 					console.log(arguments);
// 				});

// 				/*_continueWith(
// 			function(){
// 					console.log("TIMER!");
// 					console.log(arguments);
// 				}
// 					);*/

				

// 				console.log('sle');
// 				var queryUser= new Parse.Query("User");
// 				queryUser.equalTo("username",sleeper);
// 				queryUser.first({
// 					success:function(user){
// 						var userPoints=parseInt(user.get("points"));
// 						userPoints ++;
// 						userBetPoints=userPoints.toString();
// 						user.set("points",userBetPoints);
// 						console.log("22222222222");
// 						user.save();
// 						response.success("Success Message");

// 					},
// 					error:function(error){
// 						response.error("Error Message");
// 					}
// 				});

// 			}

// 			else if (parseInt(bet.get("betTime")) === parseInt(bet.get("hoursSlept"))){
// 				console.log('tiessssss');
// 				var queryUser= new Parse.Query(Parse.User);
// 				queryUser.equalTo("username",better);
// 				queryUser.first({
// 					success:function(user){
// 						var userPoints=parseInt(user.get("points"));
// 						userPoints ++;
// 						userBetPoints=userPoints.toString();
// 						user.set("points",userBetPoints);
// 						console.log("333333333333");
// 						user.save();
// 						response.success("Success Message");

// 					},
// 					error:function(error){
// 						response.error("Error Message");
// 					}
// 				});

// 				console.log("lol");
// 				var queryUser= new Parse.Query(Parse.User);
// 				queryUser.equalTo("username",sleeper);
// 				queryUser.first({
// 					success:function(user){
// 						var userPoints=parseInt(user.get("points"));
// 						userPoints +=0;
// 						userBetPoints=userPoints.toString();
// 						user.set("points",userBetPoints);
// 						console.log("4444444");
// 						user.save();
// 						response.success("Success Message");

// 					},
// 					error:function(error){
// 						response.error("Error Message");
// 					}
// 				});

// 			}

// 			else {
// 				console.log("better wins");
// 				var queryUser= new Parse.Query(Parse.User);
// 				queryUser.equalTo("username",better);
// 				console.log("You are in");
// 				queryUser.first({
// 					success:function(user){
// 						var userPoints=parseInt(user.get("points"));
// 						userPoints +=2;
// 						userBetPoints=userPoints.toString();
// 						user.set("points",userBetPoints);
// 						console.log("55555555");
// 						user.save();
// 						console.log("aaaaaaa");
// 						response.success("Success Message");

// 					},
// 					error:function(error){
// 						response.error("Error Message");
// 					}
// 				});

				
// 				console.log("lmfao");
// 				var queryUser= new Parse.Query(Parse.User);
// 				queryUser.equalTo("username",sleeper);
// 				queryUser.first({
// 					success:function(user){
// 						var userPoints=parseInt(user.get("points"));
// 						userPoints --;
// 						userBetPoints=userPoints.toString();
// 						user.set("points",userBetPoints);
// 						console.log("6666666");
// 						user.save();
// 						console.log("bbbbbbbb");
// 						response.success("Success Message");

// 					},
// 					error:function(error){
// 						response.error("Error Message");
// 					}
// 				});

// 			}

			
// 			console.log("done");
// 			response.success("Success Message %%%%%%%");

// 		},
// 		error:function(error){
// 			response.error("Error Message");
// 		}

// 	});


// });


// Parse.Cloud.define("betWinner3", function(request,response){
// 	var objectId=request.params.objectId;
// 	var query=new Parse.Query("betClass");
// 	query.equalTo("objectId",objectId);
// 	query.first({

// 		success:function(bet){
// 			//console.log("ok")
// 			var points=parseInt(bet.get("points"));
// 			var better=bet.get("better");
// 			var sleeper=bet.get("sleeper");
// 			console.log('start!!!');

			



// 			if (parseInt(bet.get("betTime")) < parseInt(bet.get("hoursSlept"))){
// 				console.log('sleeper wins');
// 				var queryUser= new Parse.Query(Parse.User);
// 				queryUser.equalTo("username",better);
// 				queryUser.first({
// 					sucess:function(user){
// 						var userPoints=parseInt(user.get("points"));
// 						userPoints ++;
// 						userBetPoints=userPoints.toString();
// 						user.set("points",userBetPoints);
// 						console.log("111111111111");
// 						user.save();
// 						response.success("Success Message");

// 					},
// 					error:function(error){
// 						response.error("Error Message");
// 					}
// 				});

// 				console.log('sle');
// 				var queryUser= new Parse.Query(Parse.User);
// 				queryUser.equalTo("username",sleeper);
// 				queryUser.first({
// 					sucess:function(user){
// 						var userPoints=parseInt(user.get("points"));
// 						userPoints ++;
// 						userBetPoints=userPoints.toString();
// 						user.set("points",userBetPoints);
// 						console.log("22222222222");
// 						user.save();
// 						response.success("Success Message");

// 					},
// 					error:function(error){
// 						response.error("Error Message");
// 					}
// 				});

// 			}

// 			else if (parseInt(bet.get("betTime")) === parseInt(bet.get("hoursSlept"))){
// 				console.log('tiessssss');
// 				var queryUser= new Parse.Query(Parse.User);
// 				queryUser.equalTo("username",better);
// 				queryUser.first({
// 					sucess:function(user){
// 						var userPoints=parseInt(user.get("points"));
// 						userPoints ++;
// 						userBetPoints=userPoints.toString();
// 						user.set("points",userBetPoints);
// 						console.log("333333333333");
// 						user.save();
// 						response.success("Success Message");

// 					},
// 					error:function(error){
// 						response.error("Error Message");
// 					}
// 				});

// 				console.log("lol");
// 				var queryUser= new Parse.Query(Parse.User);
// 				queryUser.equalTo("username",sleeper);
// 				queryUser.first({
// 					sucess:function(user){
// 						var userPoints=parseInt(user.get("points"));
// 						userPoints +=0;
// 						userBetPoints=userPoints.toString();
// 						user.set("points",userBetPoints);
// 						console.log("4444444");
// 						user.save();
// 						response.success("Success Message");

// 					},
// 					error:function(error){
// 						response.error("Error Message");
// 					}
// 				});

// 			}

// 			else {
// 				console.log("better wins");
// 				var queryUser= new Parse.Query(Parse.User);
// 				queryUser.equalTo("username",better);
// 				console.log("You are in");
// 				queryUser.first({
// 					sucess:function(user){
// 						var userPoints=parseInt(user.get("points"));
// 						userPoints +=2;
// 						userBetPoints=userPoints.toString();
// 						user.set("points",userBetPoints);
// 						console.log("55555555");
// 						user.save();
// 						console.log("aaaaaaa");
// 						response.success("Success Message");

// 					},
// 					error:function(error){
// 						response.error("Error Message");
// 					}
// 				});

// 				var u=0;
// 				for(i=0; i<1000000;i++){
// 				u=i;
// 				}

// 				console.log("lmfao");
// 				var queryUser= new Parse.Query(Parse.User);
// 				queryUser.equalTo("username",sleeper);
// 				queryUser.first({
// 					sucess:function(user){
// 						var userPoints=parseInt(user.get("points"));
// 						userPoints --;
// 						userBetPoints=userPoints.toString();
// 						user.set("points",userBetPoints);
// 						console.log("6666666");
// 						user.save();
// 						console.log("bbbbbbbb");
// 						response.success("Success Message");

// 					},
// 					error:function(error){
// 						response.error("Error Message");
// 					}
// 				});

// 			}

// 			// else if (parseInt(query.betTime) === parseInt(query.hoursSlept)){
// 			// 	points=0
// 			// }
// 			//betPoints=points.toString();


// 			//bet.set("points",betPoints);
// 			//bet.save();
// 			console.log("wiiiiiiiiiiiiiii");
// 			response.success("Success Message %%%%%%%");

// 		},
// 		error:function(error){
// 			response.error("Error Message");
// 		}

// 	});


// });

