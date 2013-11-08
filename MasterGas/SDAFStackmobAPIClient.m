//
//  SDAFStackmobAPIClient.m
//  MasterGas
//
//  Created by Stephen Lalor on 30/04/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "SDAFStackmobAPIClient.h"
#import "AFJSONRequestOperation.h"
//#import "SMJSONRequestOperation.h"


static NSString * const kSDFAPIBaseURLString = @"http://api.stackmob.com/";

//static NSString * const kSDFAPIApplicationId = @"SXkkKl2uJPIvy7yAo86fJjkVsXaOf8ClEykLR1FY";

//TODO: Enter api key
static NSString * const kSDFAPIKey = @"534a3635-62dc-47ad-8b4e-6c499044fbc6";


@implementation SDAFStackmobAPIClient

+ (SDAFStackmobAPIClient *)sharedClient {
    static SDAFStackmobAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[SDAFStackmobAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kSDFAPIBaseURLString]];
    });
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];

        [self setDefaultHeader:@"Content-Type" value:@"application/json"];
        [self setDefaultHeader:@"Accept" value:@"application/vnd.stackmob+json; version=0"];
      
        [self setDefaultHeader:@"X-StackMob-API-Key" value:kSDFAPIKey];
       // [self setDefaultHeader:@"Content-Type" value:@"application/json"];
       // [self setDefaultHeader:@"X-Parse-REST-API-Key" value:kSDFParseAPIKey];
    }
    
    return self;
}

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
   // request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"classes/%@", className] parameters:parameters];
    request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@", className] parameters:parameters];
    
    NSLog(@"request=%@", request);
    
    return request;
}

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate {
    NSMutableURLRequest *request = nil;
    NSDictionary *paramters = nil;
  
    // TODO: needs updating and putting back in.

   /* if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        NSString *jsonString = [NSString
                                stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
                                [dateFormatter stringFromDate:updatedDate]];
        
     
        
        paramters = [NSDictionary dictionaryWithObject:jsonString forKey:@"where"];
    } */
    
    request = [self GETRequestForClass:className parameters:paramters];
    return request;
}


- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"POST" path:[NSString stringWithFormat:@"classes/%@", className] parameters:parameters];
    return request;
}


- (NSMutableURLRequest *)POSTRequestForFile:(NSString *)className parameters:(NSDictionary *)parameters imageData:(NSData *)imageData imageFilename:(NSString *)imageName imageExtension:(NSString *)imageExtension {
    NSMutableURLRequest *request = nil;
    
    request = [self multipartFormRequestWithMethod:@"POST" path:@"files/" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:imageName fileName:[NSString stringWithFormat:@"%@.%@", imageName, imageExtension] mimeType:[NSString stringWithFormat:@"image/%@", imageExtension]];
    }];
    return request;
}



- (NSMutableURLRequest *)PUTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters forObjectWithId:(NSString *)objectId {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"PUT" path:[NSString stringWithFormat:@"classes/%@/%@", className, objectId] parameters:parameters];
    return request;
}


- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"DELETE" path:[NSString stringWithFormat:@"classes/%@/%@", className, objectId] parameters:nil];
    return request;
}

@end
