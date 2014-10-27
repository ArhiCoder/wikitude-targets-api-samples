<?php
/**
 *
 * A simple example how to connect with the Wikitude Cloud Targets API using
 * PHP.
 *
 * This example is published under Apache License, Version 2.0
 * http://www.apache.org/licenses/LICENSE-2.0.html
 *
 * @author Wikitude
 *
 */
include '../src/TargetsAPI.php';

// The token to use when connecting to the endpoint
$API_TOKEN = "<enter-your-token-here>";
// The version of the API we will use
$API_VERSION = 2;
// The sample image URLs we are using in this example that will be converted
$EXAMPLE_IMAGE_URLS = array(
		0 => "http://s3-eu-west-1.amazonaws.com/web-api-hosting/examples_data/surfer.jpeg",
		1 => "http://s3-eu-west-1.amazonaws.com/web-api-hosting/examples_data/biker.jpeg"
);

//create the API object
$api = new TargetsAPI($API_TOKEN, $API_VERSION);
// run the sample and print the wtc file URL to the browser
print $api->convert($EXAMPLE_IMAGE_URLS);

?>
