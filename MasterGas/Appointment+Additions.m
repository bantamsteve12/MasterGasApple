//
//  Appointment+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 01/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "Appointment+Additions.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"

@implementation Appointment (Additions)


- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
   
    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Date", @"__type",
                          [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
        
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.name, @"name",
                                    self.notes, @"notes",
                                    self.addressLine1, @"addressLine1",
                                    self.addressLine2, @"addressLine2",
                                    self.addressLine3, @"addressLine3",
                                    self.postcode, @"postcode",
                                    self.tel, @"tel",
                                    self.mobileNumber, @"mobileNumber",
                                    self.email, @"email",
                                    self.callType, @"callType",
                                    self.companyId, @"companyId",
                                    self.engineerId, @"engineerId",
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
    NSString *jsonString = nil;
    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Date", @"__type",
                          [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.name, @"name",
                                    self.notes, @"notes",
                                    self.addressLine1, @"addressLine1",
                                    self.addressLine2, @"addressLine2",
                                    self.addressLine3, @"addressLine3",
                                    self.postcode, @"postcode",
                                    self.tel, @"tel",
                                    self.mobileNumber, @"mobileNumber",
                                    self.email, @"email",
                                    self.callType, @"callType",
                                    self.companyId, @"companyId",
                                    self.engineerId, @"engineerId",
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
