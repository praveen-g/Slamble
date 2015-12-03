var requireUser = require('cloud/require-user');

var Image = Parse.Object.extend({
  className: "Image",

  title: function() {
    var title = this.get('title') || "Untitled";
    return title;
  }
});

module.exports = function() {
  var express = require('express');
  var app = express();
  
  app.locals._ = require('underscore');

  // Creates a new image
  app.post('/', function(req, res) {
    if (req.body.file) {
      var image = new Image();
      image.set("sizeOriginal", req.body.file);
      image.set("title", req.body.title);

      // Set up the ACL so everyone can read the image
      // but only the owner can have write access
      var acl = new Parse.ACL();
      acl.setPublicReadAccess(true);
      if (Parse.User.current()) {
        image.set("user", Parse.User.current());
        acl.setWriteAccess(Parse.User.current(), true);
      }
      image.setACL(acl);

      // Save the image and return some info about it via json
      image.save().then(function(image) {
        res.json({ id: image.id });
      }, function(error) {
        res.json({ error: error });
      });
    } else {
      res.json({ error: 'No file uploaded!' });
    }
  });

  // View all the latest images
  app.get('/latest', function(req, res) {
    var query = new Parse.Query(Image);

    query.descending("createdAt");
    
    query.find().then(function(objects) {
      res.render('image/list', {
        images: objects,
        title: "Latest"
      });
    });
  });

  // Shows images you uploaded
  app.get('/mine', requireUser, function(req, res) {
    var query = new Parse.Query(Image);

    query.descending("createdAt");
    query.equalTo("user", Parse.User.current());
    
    query.find().then(function(objects) {
      res.render('image/list', {
        images: objects,
        title: "My Images"
      });
    });
  });

  // Shows one image
  app.get('/:id', function(req, res) {
    var id = req.params.id;

    // Build the query to find an image by id
    var query = new Parse.Query(Image);
    query.equalTo("objectId", id);
    query.include("imageMetadata");
    
    query.find().then(function(objects) {
      if (objects.length === 0) {
        res.send("Image not found");
      } else {
        var image = objects[0];

        // Update metadata on image (adds a view)
        Parse.Cloud.run('viewImage', {
          metadataId: image.get("imageMetadata").id
        }).then(function() {
          // Render the template to show one image
          res.render('image/show', {
            image: image,
            size: 'sizeNormal',
            title: image.title()
          });
        }, function(error) {
          res.send("Error: " + error);
        });
      }
    }, function(error) {
      res.send("Image not found");
    });
  });

  return app;
}();
