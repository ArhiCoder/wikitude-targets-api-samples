/**
 * TargetsAPI shows a simple example how to interact with the Wikitude Cloud Targets API.
 * 
 * This example is published under Apache License, Version 2.0 http://www.apache.org/licenses/LICENSE-2.0.html
 * 
 * @author Wikitude
 * 
 */
/**
 * Creates a new TargetsAPI object that offers the service to interact with the Wikitude Cloud Targets API.
 * 
 * @param apiToken
 *            The token to use when connecting to the endpoint
 * @param apiVersion
 *            The version of the API we will use
 */
var TargetsAPI = function (apiToken, apiVersion) {

    // The endpoint where the Wikitude Cloud Targets API resides.
    var API_ENDPOINT = "https://api.wikitude.com/targets/wtc-url";

    /**
     * Takes an Array of Image URLs and converts them into the JSON object the Wikitude Cloud Targets API requires when
     * using a POST request.
     * 
     * @param imageUrls
     *            The imageUrls that point to the targets.
     * @return A JSON String that the Wikitude Cloud Targets API requires.
     */
    var buildPayLoad = function (images) {
        // the array of targets that we'll populate
        var targetsArray = [];
        // for each image in the array, create an object the API understands
        for (var i = 0; i < images.length; i++) {
            targetsArray.push({
                url : images[i]
            });
        }
        // return the wrapper
        return {
            targets : targetsArray
        };
    };

    /**
     * The entry point for the conversion.
     * 
     * @param imageUrls
     *            The image URLs that should be converted into a WTC file
     * @param callback
     *            the callback triggered when the request completes or fails. Needs to comply with the common (err,
     *            data) signature.
     */
    this.convert = function (imageUrls, callback) {

        /**
         * parse the response and call the callback function on success
         * 
         * @param response
         *            the HTTP response object
         */
        var parseResponse = function (response) {
            // follow the usual (error, data) structure
            callback(null, response.wtc.url);
        };

        /**
         * call the callback function with the error as sent back
         * 
         * @param response
         *            the HTTP response object
         * @param error
         *            the error that has been raised
         */
        var handleError = function (response, error) {
            // follow the usual (error, data) structure
            callback(error);
        };

        // create the JSON representation
        var payload = buildPayLoad(images);
        // send http request
        $.ajax({
            type : "POST",
            url : API_ENDPOINT,
            // we need to stringify the object as otherwise jQuery will not send the content accordingly
            data : JSON.stringify(payload),
            // set success and error handlers
            success : parseResponse,
            error : handleError,
            // the expected response type
            dataType : "json",
            // the headers
            headers : {
                "X-Api-Token" : apiToken,
                "X-Version" : apiVersion,
                "Content-Type" : "application/json"
            }
        });

    };

};