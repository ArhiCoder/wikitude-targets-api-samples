The repository highlights example implementations for various programming languages and tools how to communicate with the Wikitude Cloud Targets API. The examples are just meant to assist you getting started with the Targets API in your project.

Examples are available in the following languages and tools:

* Java (Android)
* JavaScript
* Node.js
* Objective-C
* PHP
* Python
* Ruby

Every example is structured in the following way:

* `TargetsAPI.[extension]` wraps the interaction between the client and the Wikitude Targets API.
* `TargetsAPITest.[extension]` configures the TargetsAPI object (version, token etc.) and triggers the conversion.

In addition, the following applies to all examples:

* To run the samples, the token string in `TargetsAPITest.[extension]` (currently set to `"<enter-your-token-here>"`) must be changed to a valid token. To generate a token, please check [here](http://www.wikitude.com/developer/licenses).
* Each example returns and/or prints the URL of the target collection on a successful run.
* Only very basic error handling is demonstrated. For production systems, we suggest a more comprehensive error handling.
* Unless stated otherwise, all examples are stand-alone and do not require any external dependencies to increase setup-time.
