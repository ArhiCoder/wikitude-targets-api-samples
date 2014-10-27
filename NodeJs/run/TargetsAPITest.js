/**
 * 
 * A simple example how to connect with the Wikitude Cloud Targets API using Node.js.
 * 
 * This example is published under Apache License, Version 2.0 http://www.apache.org/licenses/LICENSE-2.0.html
 * 
 * @author Wikitude
 * 
 */
var TargetsAPI = require("../src/TargetsAPI");

// The token to use when connecting to the endpoint
var API_TOKEN = "<enter-your-token-here>";
// The version of the API we will use
var API_VERSION = 2;
// The sample image URLs we are using in this example that will be converted
var EXAMPLE_IMAGE_URLS = [ "http://s3-eu-west-1.amazonaws.com/web-api-hosting/examples_data/surfer.jpeg",
        "http://s3-eu-west-1.amazonaws.com/web-api-hosting/examples_data/biker.jpeg" ];

// create wrapper
var api = new TargetsAPI(API_TOKEN, API_VERSION);
// start process
api.convert(EXAMPLE_IMAGE_URLS, function (err, url) {
    if (err) {
        console.log("Error: " + err);
    } else {
        console.log(url);
    }
});
