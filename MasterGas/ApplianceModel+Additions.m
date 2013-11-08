//
//  ApplianceModel+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 11/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "ApplianceModel+Additions.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"


@implementation ApplianceModel (Additions)


- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    
    /*NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
     @"Date", @"__type",
     [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil]; */
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.name, @"name",
                                    self.make, @"make",
                                    self.companyId, @"companyId",
                                    self.engineerId,@"engineerId",
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
