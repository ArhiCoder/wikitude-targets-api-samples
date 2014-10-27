//
//  WTTargetsAPI.h
//  WikitudeTargetAPI
//
//  Copyright (c) 2014 Wikitude. All rights reserved.
//
//
// This example is published under Apache License, Version 2.0 http://www.apache.org/licenses/LICENSE-2.0.html
//

#import <Foundation/Foundation.h>



@protocol WTTargetsAPIResponseDelegate;


@interface WTTargetsAPI : NSObject

/**
 * delegate The class which implements the delegate functions
 */
@property (nonatomic, weak) id<WTTargetsAPIResponseDelegate>        delegate;

/**
 * token The user authentication token that this api object is using
 */
@property (nonatomic, strong, readonly) NSString                    *token;

/**
 * delegate The api version that this api object is requesting
 */
@property (nonatomic, strong, readonly) NSNumber                    *apiVersion;



/**
 * Creates a new TargetsAPI object that offers the service to interact with the Wikitude Cloud Targets API.
 *
 * @param apiToken The token to use when connecting to the endpoint
 * @param apiVersion The version of the API we will use
 */
- (instancetype)initWithToken:(NSString *)token apiVersion:(NSNumber *)apiVersion;

/**
 * The entry point for the conversion.
 *
 * @param images The image URLs that should be converted into a WTC file
 * @return BOOL YES if the request was sent, NO if the images array doesn't contain any data
 */
- (BOOL)convertImageURLs:(NSArray *)imageURLs;

@end



@protocol WTTargetsAPIResponseDelegate <NSObject>

@required

/**
 * The delegate method wich is called after a successful request.
 *
 * @param json The json object as an NSDictionary which is received as a response
 */
- (void)targetsAPI:(WTTargetsAPI *)targetsAPI finishedCreatingTargetCollection:(NSDictionary *)JSONResponse;

/**
 * The delegate method wich is called in case an error occured.
 *
 * @param error The error object
 */
- (void)targetsAPI:(WTTargetsAPI *)targetsAPI failedCreatingTargetCollectionWithError:(NSError *)error;

@end
