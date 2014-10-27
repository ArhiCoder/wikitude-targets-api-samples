/**
 * 
 * A simple example how to connect with the Wikitude Cloud Targets API using
 * Java.
 * 
 * This example is published under Apache License, Version 2.0
 * http://www.apache.org/licenses/LICENSE-2.0.html
 * 
 * @author Wikitude
 * 
 */
public class TargetsAPITest {

	// The token to use when connecting to the endpoint
	private static final String API_TOKEN = "<enter-your-token-here>";
	// The version of the API we will use
	private static final int API_VERSION = 2;
	// The sample image URLs we are using in this example that will be converted
	private static final String[] EXAMPLE_IMAGE_URLS = {
			"http://s3-eu-west-1.amazonaws.com/web-api-hosting/examples_data/surfer.jpeg",
			"http://s3-eu-west-1.amazonaws.com/web-api-hosting/examples_data/biker.jpeg" };

	public static void main(String args[]) {
		try {
			// create the object
			TargetsAPI api = new TargetsAPI(API_TOKEN, API_VERSION);
			// run the sample and print the wtc file URL to the console
			System.out.println(api.convert(EXAMPLE_IMAGE_URLS));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
