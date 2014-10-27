require 'uri'
require 'net/http'
require 'json'

# TargetsAPI shows a simple example how to interact with the Wikitude Cloud Targets API.
# This example is published under Apache License, Version 2.0
# http://www.apache.org/licenses/LICENSE-2.0.html
# @author Wikitude
class TargetsAPI

  # The endpoint where the Wikitude Cloud Targets API resides.
  @@API_ENDPOINT = "http://api.wikitude.com/targets/wtc-url"
  # Creates a new TargetsAPI object that offers the service to interact with the Wikitude Cloud Targets API.
  # @param token: The token to use when connecting to the endpoint
  # @param version: The version of the API we will use
  def initialize(token, version)
    # The token to use when connecting to the endpoint
    @token = token
    # The version of the API we will use
    @version = version
  end

  private
  # Takes an Array of Image URLs and converts them into the JSON object the Wikitude Cloud Targets API requires when using a POST request.
  # @param imageUrls: The imageUrls that point to the targets.
  # @return A JSON that the Wikitude Cloud Targets API requires.
  def buildPayLoad(imageUrls)
    # create the array of target objects
    targetsArray = []
    # add each url into the array
    imageUrls.each do |image|
      targetsArray.push({
        "url" => image
      })
    end
    # return the wrapper
    return {
      "targets" => targetsArray
    }.to_json
  end

  public
  # The entry point for the conversion.
  # @param imageUrls: The image URLs that should be converted into a WTC file
  # @return the URL pointing to the WTC file
  def convert(imageUrls)

    #create URI object to be able to access the different parts of the URI
    uri = URI(@@API_ENDPOINT)

    #construct the request and prepare it with headers
    req = Net::HTTP::Post.new(uri.path)
    req["Content-Type"] = 'application/json'
    req["X-Api-Token"] = @token
    req["X-Version"] = @version

    # prepare the body payload
    req.body = buildPayLoad(imageUrls)

    #send the request
    response = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req) }
    if response.code == "200"
      #parse the JSON object and return the WTC URL
      return JSON.parse(response.body)["wtc"]["url"]
    else
      #do some error handling! For now, we just print the response code and body
      puts "Error: #{response.message} (#{response.code}): #{response.body}"
    end
  end
end