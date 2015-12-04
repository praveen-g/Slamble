// Use this middleware to require that a user is logged in
module.exports = function(req, res, next) {
  if (Parse.User.current()) {
    next();
  } else {
    res.send("You need to be logged in to see this page.");
  }
}
