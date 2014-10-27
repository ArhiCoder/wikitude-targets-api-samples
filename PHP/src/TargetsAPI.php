<?php

/**
 * TargetsAPI shows a simple example how to interact with the Wikitude Cloud Targets API.
 *
 * This example is published under Apache License, Version 2.0 http://www.apache.org/licenses/LICENSE-2.0.html
 *
 * @author Wikitude
 *
 */
class TargetsAPI {

	// The endpoint where the Wikitude Cloud Targets API resides.
	private $API_ENDPOINT = "https://api.wikitude.com/targets/wtc-url/";
	// The token to use when connecting to the endpoint
	private $apiToken = null;
	// The version of the API we will use
	private $apiVersion = null;

	/**
	 * Creates a new TargetsAPI object that offers the service to interact with
	 * the Wikitude Cloud Targets API.
	 *
	 * @param $token
	 *            The token to use when connecting to the endpoint
	 * @param $version
	 *            The version of the API we will use
	 */
	function __construct($token, $version) {
		//initialize the values
		$this->apiToken = $token;
		$this->apiVersion = $version;
	}

	/**
	 * Takes an Array of Image URLs and converts them into the JSON object the
	 * Wikitude Cloud Targets API requires when using a POST request.
	 *
	 * @param $imageUrls
	 *            The imageUrls that point to the targets.
	 * @return A JSON String that the Wikitude Cloud Targets API requires.
	 */
	private function buildPayLoad( $imageUrls ){
		// create the array of target objects
		$targets = array();
		// add each url into the array
		for($i = 0, $length = count($imageUrls); $i < $length; ++$i) {
			$targets[$i] = array(
					"url" => $imageUrls[$i]
			);
		}
		//return the wrapper
		return array(
				"targets" => $targets
		);
	}

	/**
	 * The entry point for the conversion.
	 *
	 * @param $images
	 *            The image URLs that should be converted into a WTC file
	 * @return the URL pointing to the WTC file
	 */
	public function convert($images){
		//create the payload
		$data = $this->buildPayLoad($images);

		//configure the request
		$options = array(
				'http' => array(
						'method' => 'POST',
						'content' => json_encode( $data ),
						'header'=>  "Content-Type: application/json\r\n" .
						"X-Version: " . $this->apiVersion . "\r\n" .
						"X-Api-Token: " . $this->apiToken . "\r\n"
				)
		);

		//prepare the request
		$context  = stream_context_create( $options );
		//send the request
		try{
			$result = file_get_contents( $this->API_ENDPOINT, false, $context );
			//parse the result
			$response = json_decode( $result , true);
			//print the output
			return $response["wtc"]["url"];
		} catch (Exception $e) {
			//in case of an error, show the error and return null
			print "Exception: " .  $e->getMessage() . "\n";
		}
		
	}

}
?>