//
//  Customer+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 01/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "Customer+Additions.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"

@implementation Customer (Additions)


- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
 

    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.name, @"name",
                                    self.addressLine1, @"addressLine1",
                                    self.addressLine2, @"addressLine2",
                                    self.addressLine3, @"addressLine3",
                                    self.postcode, @"postcode",
                                    self.tel, @"tel",
                                    self.email, @"email",
                                    self.notes, @"notes",
                                    self.mobileNumber, @"mobileNumber",
                                    self.customerNo, @"customerNo",
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
                                    self.name, @"name",
                                    self.addressLine1, @"addressLine1",
                                    self.addressLine2, @"addressLine2",
                                    self.addressLine3, @"addressLine3",
                                    self.postcode, @"postcode",
                                    self.tel, @"tel",
                                    self.email, @"email",
                                    self.notes, @"notes",
                                    self.mobileNumber, @"mobileNumber",
                                    self.customerNo, @"customerNo",
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
