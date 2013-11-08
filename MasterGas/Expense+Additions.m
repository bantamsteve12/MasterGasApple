//
//  Expense+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 25/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "Expense+Additions.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"

@implementation Expense (Additions)


- (NSDictionary *)JSONToCreateObjectOnServer {
    
    
    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"Date", @"__type",
                                    [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];

    
    NSString *jsonString = nil;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.uniqueClaimNo, @"uniqueClaimNo",
                                    self.reference, @"reference",
                                    date, @"date",
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
    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Date", @"__type",
                          [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    
    
    NSString *jsonString = nil;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.uniqueClaimNo, @"uniqueClaimNo",
                                    self.reference, @"reference",
                                    date, @"date",
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