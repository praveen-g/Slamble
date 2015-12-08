<% var userQuery = new Parse.Query(Parse.User);
      userQuery.greaterThan("Points", 0);
      userQuery.find({

      success: function (results) {
      var results,
      rlen = results.length,
        username,
        points,
        firstName
        lastName;

      },
      error: function(error) {
      // throw "Got an error " + error.code + " : " + error.message;
      status.error("error" + error);
    }
  });
  %>

     
    <% 
      var userId = Parse.User.current().get('objectId');
      console.log(userId);
      sleepQuery = new Parse.Query("sleep");
      sleepQuery.equalTo("userId", userId);
      sleepQuery.find({
        success: function (results) {
            var i,
            rlen = results.length,
            sleepTime,
            sleepObject,
            createdAt;
            var createdAtArr = [];
            var sleepTimeArr = [];
            for (i = 0; i < 8; i++) {
              sleepObject = results[i];
              sleepTime = parseInt(sleepObject.get("sleep"));
              createdAt =sleepObject.get("createdAt");
              sleepTimeArr.push(sleepTime);
              createdAtArr.push(createdAt);
            }
            console.log(sleepTimeArr);
            console.log(createdAtArr);
        },error: function(error) {
          console.log("Error: " + error.code + " " + error.message);
        }
      });
    %> 
