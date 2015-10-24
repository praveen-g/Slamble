
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});


Parse.Cloud.define("bet",function(request,response){
	var objectId = request.params.objectId;

	var query = new Parse.Query("betClass");
	query.get(objectId,{
		success:function(bet){
			response.success(bet.get("better")+" "+"has bet"+bet.get("sleeper")+ " " +"to sleep at least"+ " " + bet.get("betTime"));
		},
		error:function(error){
			response.error(error.message);
		}
	});
});

	
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

Parse.Cloud.define("betWinner", function(request,response){
	var objectId=request.params.objectId;
	var query=new Parse.Query("betClass");
	query.equalTo("objectId",objectId);
	query.first({

		success:function(bet){
			//console.log("ok")
			if(bet.get("betterPoints") !== undefined){
				var betterPoints=parseInt(bet.get("betterPoints"));
			}
			else{
				var betterPoints=0;
			}
			
			if(bet.get("sleeperPoints") !== undefined){
				var sleeperPoints=parseInt(bet.get("sleeperPoints"));
			}
			else{
				var sleeperPoints=0;
			}
			if (parseInt(bet.get("betTime")) < parseInt(bet.get("hoursSlept"))){
				betterPoints ++;
				sleeperPoints ++;

			}

			else if (parseInt(bet.get("betTime")) === parseInt(bet.get("hoursSlept"))){
				betterPoints ++;
				sleeperPoints +=0;

			}

			else {
				betterPoints +=2;
				sleeperPoints --;
			}

			// else if (parseInt(query.betTime) === parseInt(query.hoursSlept)){
			// 	points=0
			// }
			betterBetPoints=betterPoints.toString();
			sleeperBetPoints=sleeperPoints.toString();

			bet.set("betterPoints",betterBetPoints);
			bet.set("sleeperPoints",sleeperBetPoints);
			bet.save();
			response.success("Success Message");

		},
		error:function(error){
			response.error("Error Message");
		}

	});


});


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

Parse.Cloud.define("betWinner2", function(request,response){
	var objectId=request.params.objectId;
	var query=new Parse.Query("betClass");

console.log("--= Function STart =--");
console.log("Object ID: "+ objectId);

	query.equalTo("objectId",objectId);

 	query.count().then(function(cnt){
	   console.log("THE NUMBER OF OBJECTS FOUND IS: " +cnt);

 	}, function(){
 		console.log("Fail");
 		console.log(arguments);
 	}).always(function(){
 		console.log('Count Happened');
 	});


	query.first({

		success:function(bet){
			//console.log("ok")
			var points=parseInt(bet.get("points"));
			var better=bet.get("better");
			var sleeper=bet.get("sleeper");
			console.log('start!!!');

			console.log(better + " bet "+sleeper+" will sleep "+bet.get("betTime"));


			if (parseInt(bet.get("betTime")) < parseInt(bet.get("hoursSlept"))){
				console.log('sleeper wins');
				var queryUser= new Parse.Query("User");
				console.log("created query "+queryUser);
				queryUser.equalTo("username",better);
				console.log("added constraint to "+JSON.stringify(queryUser.toJSON()));
				queryUser.first(
					/*success:function(user){
						console.log("Got user obj");
						var userPoints=parseInt(user.get("points"));
						userPoints ++;
						userBetPoints=userPoints.toString();
						console.log("New points = "+userBetPoints);
						user.set("points",userBetPoints);
						console.log("111111111111");
						user.save();
						response.success("Success Message");
					},
					error:function(error){
						console.log("got error "+error);
						response.error("Error Message");
					}
				}*/
				).always(function(){
console.log('ALWASY');
					console.log(arguments);
				});

				/*_continueWith(
			function(){
					console.log("TIMER!");
					console.log(arguments);
				}
					);*/

				

				console.log('sle');
				var queryUser= new Parse.Query("User");
				queryUser.equalTo("username",sleeper);
				queryUser.first({
					success:function(user){
						var userPoints=parseInt(user.get("points"));
						userPoints ++;
						userBetPoints=userPoints.toString();
						user.set("points",userBetPoints);
						console.log("22222222222");
						user.save();
						response.success("Success Message");

					},
					error:function(error){
						response.error("Error Message");
					}
				});

			}

			else if (parseInt(bet.get("betTime")) === parseInt(bet.get("hoursSlept"))){
				console.log('tiessssss');
				var queryUser= new Parse.Query(Parse.User);
				queryUser.equalTo("username",better);
				queryUser.first({
					success:function(user){
						var userPoints=parseInt(user.get("points"));
						userPoints ++;
						userBetPoints=userPoints.toString();
						user.set("points",userBetPoints);
						console.log("333333333333");
						user.save();
						response.success("Success Message");

					},
					error:function(error){
						response.error("Error Message");
					}
				});

				console.log("lol");
				var queryUser= new Parse.Query(Parse.User);
				queryUser.equalTo("username",sleeper);
				queryUser.first({
					success:function(user){
						var userPoints=parseInt(user.get("points"));
						userPoints +=0;
						userBetPoints=userPoints.toString();
						user.set("points",userBetPoints);
						console.log("4444444");
						user.save();
						response.success("Success Message");

					},
					error:function(error){
						response.error("Error Message");
					}
				});

			}

			else {
				console.log("better wins");
				var queryUser= new Parse.Query(Parse.User);
				queryUser.equalTo("username",better);
				console.log("You are in");
				queryUser.first({
					success:function(user){
						var userPoints=parseInt(user.get("points"));
						userPoints +=2;
						userBetPoints=userPoints.toString();
						user.set("points",userBetPoints);
						console.log("55555555");
						user.save();
						console.log("aaaaaaa");
						response.success("Success Message");

					},
					error:function(error){
						response.error("Error Message");
					}
				});

				
				console.log("lmfao");
				var queryUser= new Parse.Query(Parse.User);
				queryUser.equalTo("username",sleeper);
				queryUser.first({
					success:function(user){
						var userPoints=parseInt(user.get("points"));
						userPoints --;
						userBetPoints=userPoints.toString();
						user.set("points",userBetPoints);
						console.log("6666666");
						user.save();
						console.log("bbbbbbbb");
						response.success("Success Message");

					},
					error:function(error){
						response.error("Error Message");
					}
				});

			}

			
			console.log("done");
			response.success("Success Message %%%%%%%");

		},
		error:function(error){
			response.error("Error Message");
		}

	});


});


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

