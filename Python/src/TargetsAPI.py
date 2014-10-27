import urllib2
import json

# TargetsAPI shows a simple example how to interact with the Wikitude Cloud Targets API.
# This example is published under Apache License, Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
# @author Wikitude
class TargetsAPI:

    # The endpoint where the Wikitude Cloud Targets API resides.
    API_ENDPOINT = "https://api.wikitude.com/targets/wtc-url/"

    # Creates a new TargetsAPI object that offers the service to interact with the Wikitude Cloud Targets API.
    # @param token: The token to use when connecting to the endpoint
    # @param version: The version of the API we will use
    def __init__(self, token, version):
        # The token to use when connecting to the endpoint
        self.token = token
        # The version of the API we will use
        self.version = version
    
    # Takes an Array of Image URLs and converts them into the JSON object the Wikitude Cloud Targets API requires when using a POST request.
    # @param imageUrls: The imageUrls that point to the targets.
    # @return A JSON that the Wikitude Cloud Targets API requires.
    def __generatePayload(self, imageUrls):
        # create the array of target objects
        targets = []
        # add each url into the array
        for image in imageUrls:
            targets.append({'url' : image})
        # return the wrapper
        return {'targets' : targets}
    
    # The entry point for the conversion.
    # @param imageUrls: The image URLs that should be converted into a WTC file
    # @return the URL pointing to the WTC file
    def convert(self, imageUrls):
        # the HTTP headers to be sent to the Wikitude Clous Targets API 
        headers = {
                   'Content-Type' : 'application/json',
                   'X-Api-Token' : self.token,
                   'X-Version' : self.version
        }
        # prepare the request with data and headers
        req = urllib2.Request(TargetsAPI.API_ENDPOINT, json.dumps(self.__generatePayload(imageUrls)), headers)
        # open the request and fetch the data
        try:
            response = urllib2.urlopen(req)
        except urllib2.URLError, e:
            # in case of a connection error
            if e.code != 200:
                print 'Error:', e
        else:
            # get the HTTPresponse
            content = response.read()
            # print the resulting wtc file URL
            return json.loads(str(content)).get('wtc').get('url')
