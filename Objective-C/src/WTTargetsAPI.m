//
//  WTTargetsAPI.m
//  WikitudeTargetAPI
//
//  Copyright (c) 2014 Wikitude. All rights reserved.
//
//
// This example is published under Apache License, Version 2.0 http://www.apache.org/licenses/LICENSE-2.0.html
//

#import "WTTargetsAPI.h"



/* The endpoint where the Wikitude Cloud Targets API resides. */
NSString* const kWTAPI_ENDPOINT = @"https://api.wikitude.com/targets/wtc-url";


@interface WTTargetsAPI ()

@property (nonatomic, strong) NSString              *internalToken;
@property (nonatomic, strong) NSNumber              *internalAPIVersion;

@end


@implementation WTTargetsAPI

/**
 * Creates a new TargetsAPI object that offers the service to interact with the Wikitude Cloud Targets API.
 *
 * @param apiToken The token to use when connecting to the endpoint
 * @param apiVersion The version of the API we will use
 * @param delegate The class which implements the delegate functions
 */
- (instancetype)initWithToken:(NSString *)token apiVersion:(NSNumber *)apiVersion
{
    self = [super init];
    if (self)
    {
        _internalToken = token;
        _internalAPIVersion = apiVersion;
    }

    return self;
}


- (NSString *)token
{
    return _internalToken;
}

- (NSNumber *)apiVersion
{
    return _internalAPIVersion;
}

#pragma mark - Public Methods

/**
 * The entry point for the conversion.
 *
 * @param images The image URLs that should be converted into a WTC file
 * @return BOOL YES if the request was sent, NO if the images array doesn't contain any data
 */
- (BOOL)convertImageURLs:(NSArray *)imageURLs
{
    BOOL conversionRequestSend = NO;
    
    if( imageURLs)
    {
        // get json string that will be sent in the body of the post request
        NSData* requestBodyData = [self JSONDataForTargetImageURLs:imageURLs];
        if ( requestBodyData )
        {
            // create the request object and initialize it with the endpoint url
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:kWTAPI_ENDPOINT]];
            
            // set http method to post
            [request setHTTPMethod:@"POST"];
            
            // set http body
            [request setHTTPBody:requestBodyData];
            
            // set necessary header properties
            [request setValue:_internalToken forHTTPHeaderField:@"X-Api-Token"];
            [request setValue:[_internalAPIVersion stringValue] forHTTPHeaderField:@"X-Version"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            // create the connection and fire send request
            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
            {
                // evaluate the response
                if ( data )
                {
                    // call the delegate success function with the data object as a parameter
                    NSError *jsonReadError = nil;
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonReadError];
                    if ( jsonObject && [jsonObject isKindOfClass:[NSDictionary class]] )
                    {
                        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
                        if ( 200 == httpURLResponse.statusCode )
                        {
                            [self.delegate targetsAPI:self finishedCreatingTargetCollection:jsonObject];
                        }
                        else
                        {
                            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [jsonObject objectForKey:@"message" ],
                                                       NSLocalizedFailureReasonErrorKey: [jsonObject objectForKey:@"reason"],
                                                       NSLocalizedRecoverySuggestionErrorKey: [jsonObject objectForKey:@"moreInfo"]};
                            NSError *targetsAPIError = [NSError errorWithDomain:@"com.wikitude.targetsAPI" code:httpURLResponse.statusCode userInfo:userInfo];
                            
                            [self.delegate targetsAPI:self failedCreatingTargetCollectionWithError:targetsAPIError];
                        }
                    }
                    else
                    {
                        [self.delegate targetsAPI:self failedCreatingTargetCollectionWithError:jsonReadError];
                    }
                }
                else
                {
                    // call the delegate error function with the error object as a parameter in case an error occures
                    [self.delegate targetsAPI:self failedCreatingTargetCollectionWithError:error];
                }
            }];
            
            conversionRequestSend = YES;
        }
    }

    return conversionRequestSend;
}


#pragma mark - Private Methods

/**
 * The entry point for the conversion.
 * Assumes that the images array contains valid image urls
 *
 * @param images The image URLs that should be converted into a WTC file
 */
- (NSData *)JSONDataForTargetImageURLs:(NSArray *)targetImageURLs
{
    NSData *jsonData = nil;
 
    
    NSMutableArray *jsonTargetImageURLs = [NSMutableArray array];
    for (NSString *targetImageURL in targetImageURLs)
    {
        [jsonTargetImageURLs addObject:@{@"url": targetImageURL}];
    }
    
    NSDictionary *jsonObject = @{@"targets": jsonTargetImageURLs};
    
    
    NSError *jsonWriteError = nil;
    jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:&jsonWriteError];

    if ( !jsonData )
    {
        NSLog(@"Error generating JSON Data for target images: '%@'", jsonWriteError);
    }

    return jsonData;
}

@end
