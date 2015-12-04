var express = require('express');
var expressLayouts = require('cloud/express-layouts');
var parseExpressCookieSession = require('parse-express-cookie-session');
var parseExpressHttpsRedirect = require('parse-express-https-redirect');

var app = express();

// Global app configuration section
app.set('views', 'cloud/views');  // Specify the folder to find templates
app.set('view engine', 'ejs');    // Set the template engine
app.use(expressLayouts);          // Use the layout engine for express
app.use(parseExpressHttpsRedirect());    // Automatically redirect non-secure urls to secure ones
app.use(express.bodyParser());    // Middleware for reading request body
app.use(express.methodOverride());
app.use(express.cookieParser('SECRET_SIGNING_KEY'));
app.use(parseExpressCookieSession({
  fetchUser: true,
  key: 'image.sess',
  cookie: {
    maxAge: 3600000 * 24 * 30
  }
}));



app.locals._ = require('underscore');

var Image = Parse.Object.extend("Image");

Homepage endpoint
app.get('/', function(req, res) {
  // Get the latest images to show
  var query = new Parse.Query('BetClass');
  query.descending("createdAt");
  query.limit(7);
  
  query.find().then(function(objects) {
    res.render('home', { images: objects });
  });
});

User endpoints
app.use('/', require('cloud/user'));

// Image endpoints
app.use('/i', require('cloud/image'));

Attach the Express app to Cloud Code.
app.listen();
