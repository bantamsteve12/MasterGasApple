//
//  SDAFParseAPIClient.h
//  SignificantDates
//
//  Created by Chris Wagner on 7/1/12.
//

#import "AFHTTPClient.h"

@interface SDAFParseAPIClient : AFHTTPClient

+ (SDAFParseAPIClient *)sharedClient;

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate;
- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)PUTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters forObjectWithId:(NSString *)objectId;
- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId;

@end
