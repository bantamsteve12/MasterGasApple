//
//  MileageItem+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 05/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "MileageItem+Additions.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"


@implementation MileageItem (Additions)

- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    
    
    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Date", @"__type",
                          [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.journeyDescription, @"journeyDescription",
                                    self.startMileage, @"startMileage",
                                    self.finishMileage, @"finishMileage",
                                    self.totalMileage, @"totalMileage",
                                    self.journeyNotes, @"journeyNotes",
                                    self.vehicleRegistration, @"vehicleRegistration",
                                    date, @"date",
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
    
    
    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Date", @"__type",
                          [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    
    
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.journeyDescription, @"journeyDescription",
                                    self.startMileage, @"startMileage",
                                    self.finishMileage, @"finishMileage",
                                    self.totalMileage, @"totalMileage",
                                    self.journeyNotes, @"journeyNotes",
                                    self.vehicleRegistration, @"vehicleRegistration",
                                    date, @"date",
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