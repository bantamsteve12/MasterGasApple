//
//  SDAFStackmobAPIClient.h
//  MasterGas
//
//  Created by Stephen Lalor on 30/04/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "AFHTTPClient.h"

@interface SDAFStackmobAPIClient : AFHTTPClient

+ (SDAFStackmobAPIClient *)sharedClient;


- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate;
- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)PUTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters forObjectWithId:(NSString *)objectId;
- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId;

@end

