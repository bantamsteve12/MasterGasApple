#import "SDAFParseAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kSDFParseAPIBaseURLString = @"https://api.parse.com/1/";
static NSString * const kSDFParseAPIApplicationId = @"SXkkKl2uJPIvy7yAo86fJjkVsXaOf8ClEykLR1FY";
static NSString * const kSDFParseAPIKey = @"v1hYnpMP6sypiNcTWYumjTXkEXyW8oI00OatNsMA";

@implementation SDAFParseAPIClient

+ (SDAFParseAPIClient *)sharedClient {
    static SDAFParseAPIClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[SDAFParseAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kSDFParseAPIBaseURLString]];
    }); 
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self setDefaultHeader:@"X-Parse-Application-Id" value:kSDFParseAPIApplicationId];
        [self setDefaultHeader:@"X-Parse-REST-API-Key" value:kSDFParseAPIKey];
    }
    
    return self;
}

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    
    NSLog(@"params = %@", parameters);
    
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"classes/%@", className] parameters:parameters];
 
    
    return request;
}

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate {
    NSMutableURLRequest *request = nil;
    NSDictionary *paramters = nil;
    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        
        NSString *jsonString = [NSString 
                                stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}", 
                                [dateFormatter stringFromDate:updatedDate]];
     
    
        paramters = [NSDictionary dictionaryWithObject:jsonString forKey:@"where"];
  
    }
    
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
