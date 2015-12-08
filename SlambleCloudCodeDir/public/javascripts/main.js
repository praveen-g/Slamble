Uploader = Backbone.View.extend({
  events: {
    "submit": "upload",
    "change input[type=file]": "upload",
    "click .upload": "showFile"
  },
  
  initialize: function() {
    var self = this;
    this.fileUploadControl = this.$el.find("input[type=file]")[0];
  },

  showFile: function(e) {
    this.fileUploadControl.click();
    return false;
  },

  upload: function() {
    var self = this;
    
    if (this.fileUploadControl.files.length > 0) {
      this.$(".upload").html("Uploading <img src='/images/spinner.gif' />");
      var file = this.fileUploadControl.files[0];
      var name = "image.jpg";
      var parseFile = new Parse.File(name, file);

      // First, we save the file using the javascript sdk
      parseFile.save().then(function() {
        // Then, we post to our custom endpoint which will do the post
        // processing necessary for the image page
        $.post("/i", {
          file: {
            "__type": "File",
            "url": parseFile.url(),
            "name": parseFile.name()
          },
          title: self.$("[name=title]").val()
        }, function(data) {
          window.location.href = "/i/" + data.id;
        });
      });
    } else {
      alert("Please select a file");
    }

    return false;
  }
});




$(function() {
  // Make all of special links magically post the form
  // when it has a particular data-action associated
  $("a[data-action='post']").click(function(e) {
    var el = $(e.target);
    el.closest("form").submit();
    return false;
  });
});


(function($) {
  $("#enterSleep").click(function(){
    var userId = Parse.User.current().get('objectId');
    var firstName = Parse.User.current().get('firstName');
    var lastName = Parse.User.current().get('lastName');
    var hoursSlept= parseInt($("#hoursSlept").val());
    console.log("username " + username);
    console.log("userId " + userId);
    console.log("firstName " + firstName);
    console.log("lastName " + lastName);
    console.log("hoursSlept " + hoursSlept);

    // var sleep = Parse.Object.extend("Sleep");
    var sleep = Parse.Object.extend("Sleep");
    var sleep = new Sleep();
    sleep.set('username', username);
    sleep.set('sleep', hoursSlept);
    sleep.set('userId', userId);
    sleep.set('firstName', firstName);
    sleep.set('lastName', lastName);

      console.log("sleep is" + sleep);

      mySleep.save(null, {
        success: function(mySleep) {
          // Execute any logic that should take place after the object is saved.
            alert('New object created with objectId: ' + sleep.id);
            res.success("saved sleep Object");
          },
          error: function(mySleep, error) {
            // Execute any logic that should take place if the save fails.
            // error is a Parse.Error with an error code and message.
            alert('Failed to create new object, with error code: ' + error.message);
            res.error(error);
          }
      }); 
  });
});          
