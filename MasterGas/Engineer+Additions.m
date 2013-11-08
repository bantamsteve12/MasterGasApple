//
//  Engineer+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 21/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "Engineer+Additions.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"


@implementation Engineer (Additions)


- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.engineerName, @"engineerName",
                                    self.engineerGSRIDNumber, @"engineerGSRIDNumber",
                                    self.engineerSignatureFilename, @"engineerSignatureFilename",
                                    self.active, @"active",
                                    self.companyId, @"companyId",
                                    self.engineerId, @"engineerId",
                                    nil];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:jsonDictionary
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    if (!jsonData) {
        NSLog(@"Error creaing jsonData: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonDictionary;
}



- (NSDictionary *)JSONToEditObjectOnServer {
    NSString *jsonString = nil;
    
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.engineerName, @"engineerName",
                                    self.engineerGSRIDNumber, @"engineerGSRIDNumber",
                                    self.engineerSignatureFilename, @"engineerSignatureFilename",
                                    self.active, @"active",
                                    self.companyId, @"companyId",
                                    self.engineerId, @"engineerId",
                                    nil];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:jsonDictionary
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    if (!jsonData) {
        NSLog(@"Error creaing jsonData: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonDictionary;
}



@end