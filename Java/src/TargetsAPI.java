import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLDecoder;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * TargetsAPI shows a simple example how to interact with the Wikitude Cloud
 * Targets API.
 * 
 * This example is published under Apache License, Version 2.0
 * http://www.apache.org/licenses/LICENSE-2.0.html
 * 
 * @author Wikitude
 * 
 */
public class TargetsAPI {

	// The endpoint where the Wikitude Cloud Targets API resides.
	// *********************************************************************
	// ***************************** IMPORTANT *****************************
	// *********************************************************************
	// In case you get the following error when running the code:
	// "unable to find valid certification path to requested target",
	// your JVM does not recognize the SSL Certificate Authority (CA) Wikitude
	// is using. In this case, you either need to switch to http connections
	// (which causes your API Token to be transmitted in plain text over the
	// net), or you add the certificate to your certificate store. A tutorial
	// how to do that can be found at
	// https://blogs.oracle.com/gc/entry/unable_to_find_valid_certification
	private static final String API_ENDPOINT = "https://api.wikitude.com/targets/wtc-url/";

	// The token to use when connecting to the endpoint
	private String apiToken;
	// The version of the API we will use
	private int apiVersion;

	/**
	 * Creates a new TargetsAPI object that offers the service to interact with
	 * the Wikitude Cloud Targets API.
	 * 
	 * @param token
	 *            The token to use when connecting to the endpoint
	 * @param version
	 *            The version of the API we will use
	 */
	public TargetsAPI(String token, int version) {
		this.apiToken = token;
		this.apiVersion = version;
	}

	/**
	 * Takes an Array of Image URLs and converts them into the JSON object the
	 * Wikitude Cloud Targets API requires when using a POST request.
	 * 
	 * Remark: We use the open source JSON reference implementation for Java
	 * available at https://github.com/douglascrockford/JSON-java in order to
	 * handle JSON objects.
	 * 
	 * @param imageUrls
	 *            The imageUrls that point to the targets.
	 * @return A JSON object that the Wikitude Cloud Targets API requires.
	 */
	private JSONObject buildPayLoad(String[] imageUrls) {

		try {
			// create the array of target objects
			JSONArray urls = new JSONArray();
			// add each url into the array
			for (String imageUrl : imageUrls) {
				JSONObject obj = new JSONObject().put("url",
						URLDecoder.decode(imageUrl, "UTF-8"));
				urls.put(obj);
			}

			// return the JSON object that follows the API structure
			return new JSONObject().put("targets", urls);

		} catch (UnsupportedEncodingException e) {
			// in case UTF-8 is not available on the platform
			System.err.println("Encoding UTF-8 is not supported");
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * Send the POST request to the Wikitude Cloud Targets API.
	 * 
	 * <b>Remark</b>: We are not using any external libraries for sending HTTP
	 * requests, to be as independent as possible. Libraries like Apache
	 * HttpComponents (included in Android already) make it a lot easier to
	 * interact with HTTP connections.
	 * 
	 * @param body
	 *            The JSON body that is sent in the request.
	 * @return The response from the server, in JSON format
	 * 
	 * @throws IOException
	 *             when the server cannot serve the request for any reason, or
	 *             anything went wrong during the communication between client
	 *             and server.
	 * 
	 */
	private String sendRequest(String body) throws IOException {

		BufferedReader reader = null;
		OutputStreamWriter writer = null;

		try {

			// create the URL object from the endpoint
			URL url = new URL(API_ENDPOINT);

			// open the connection
			HttpURLConnection connection = (HttpURLConnection) url
					.openConnection();

			// use POST and configure the connection
			connection.setRequestMethod("POST");
			connection.setDoInput(true);
			connection.setDoOutput(true);
			connection.setUseCaches(false);

			// set the request headers
			connection.setRequestProperty("Content-Type", "application/json");
			connection.setRequestProperty("X-Api-Token", apiToken);
			connection.setRequestProperty("X-Version", "" + apiVersion);
			connection.setRequestProperty("Content-Length",
					String.valueOf(body.length()));

			// construct the writer and write request
			writer = new OutputStreamWriter(connection.getOutputStream());
			writer.write(body);
			writer.flush();

			// listen on the server response
			reader = new BufferedReader(new InputStreamReader(
					connection.getInputStream()));

			// construct the server response and return
			StringBuilder sb = new StringBuilder();
			for (String line; (line = reader.readLine()) != null;) {
				sb.append(line);
			}

			// return the result
			return sb.toString();

		} catch (MalformedURLException e) {
			// the URL we specified as endpoint was not valid
			System.err.println("The URL " + API_ENDPOINT
					+ " is not a valid URL");
			e.printStackTrace();
			return null;
		} catch (ProtocolException e) {
			// this should not happen, it means that we specified a wrong
			// protocol
			System.err
					.println("The HTTP method is not valid. Please check if you specified POST.");
			e.printStackTrace();
			return null;
		} finally {
			// close the reader and writer
			try {
				writer.close();
			} catch (Exception e) {
				// intentionally left blank
			}
			try {
				reader.close();
			} catch (Exception e) {
				// intentionally left blank
			}
		}
	}

	/**
	 * Parse the JSON response and return the WTC URL from it
	 * 
	 * @param response
	 *            the String response from the server request
	 * @return the URL pointing to the WTC file
	 */
	private String parseResponse(String response) {
		JSONObject object = new JSONObject(response);
		return ((JSONObject) object.get("wtc")).get("url").toString();
	}

	/**
	 * The entry point for the conversion.
	 * 
	 * @param imageUrls
	 *            The image URLs that should be converted into a WTC file
	 * @return the URL pointing to the WTC file
	 * @throws IOException
	 *             when anything goes wrong in the server communication
	 */
	public String convert(String[] imageUrls) throws IOException {
		String body = this.buildPayLoad(imageUrls).toString();
		String response = this.sendRequest(body);
		return this.parseResponse(response);
	}

}
