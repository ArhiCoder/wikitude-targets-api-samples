//
//  ViewController.m
//  WikitudeTargetAPI
//
//  Copyright (c) 2014 Wikitude. All rights reserved.
//
//
// This example is published under Apache License, Version 2.0 http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "ViewController.h"
#import "WTTargetsAPI.h"



// The token to use when connecting to the endpoint
NSString * const kWTAPI_TOKEN = @"<enter-your-token-here>";

// The version of the API we will use
NSUInteger const kWTAPI_VERSION = 1;


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create target api object
    WTTargetsAPI *targetAPI = [[WTTargetsAPI alloc] initWithToken:kWTAPI_TOKEN apiVersion:@(kWTAPI_VERSION)];
    targetAPI.delegate = self;
    
    // The sample image URLs we are using in this example
    NSArray *targetImageURLs = @[@"http://s3-eu-west-1.amazonaws.com/web-api-hosting/examples_data/surfer.jpeg",
                                 @"http://s3-eu-west-1.amazonaws.com/web-api-hosting/examples_data/biker.jpeg"];
    
    // start converting the images and send the request
    if ( ![targetAPI convertImageURLs:targetImageURLs] )
    {
        NSLog(@"Error sending Wikitude target api request");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -Delegation
#pragma mark WTTargetsAPIResponseDelegate

// target api delegate success method
- (void)targetsAPI:(WTTargetsAPI *)targetsAPI finishedCreatingTargetCollection:(NSDictionary *)JSONResponse
{
    NSLog(@"Wikitude target api (token: '%@' - apiversion: '%@') returned response: %@", targetsAPI.token, targetsAPI.apiVersion, JSONResponse);
}

// target api delegate error method
- (void)targetsAPI:(WTTargetsAPI *)targetsAPI failedCreatingTargetCollectionWithError:(NSError *)error
{
    NSLog(@"Wikitude target api (token: '%@' - apiversion: '%@') returned with error: %@", targetsAPI.token, targetsAPI.apiVersion, error);
}

@end
