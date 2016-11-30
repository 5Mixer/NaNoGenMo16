// A server is required as a local HTML file cannot access remote dictionairy API's because of cross origin policies.

var express = require('express');
var app = express();

app.use(express.static('public'));

app.listen(3000, function () {
  console.log('App listening on port 3000!');
});
