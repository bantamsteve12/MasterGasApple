//
//  Invoice+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 08/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "Invoice+Additions.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"

@implementation Invoice (Additions)


- (NSDictionary *)JSONToCreateObjectOnServer {
    
    
    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Date", @"__type",
                          [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    
    NSDictionary *due = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Date", @"__type",
                          [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    
    
    NSString *jsonString = nil;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.uniqueInvoiceNo, @"uniqueInvoiceNo",
                                    date, @"date",
                                    due, @"due",
                                    self.customerName, @"customerName",
                                    self.customerAddressLine1, @"customerAddressLine1",
                                    self.customerAddressLine2, @"customerAddressLine2",
                                    self.customerAddressLine3, @"customerAddressLine3",
                                    self.customerPostcode, @"customerPostcode",
                                    self.customerTelephone, @"customerTelephone",
                                    self.customerMobile, @"customerMobile",
                                    self.customerEmail, @"customerEmail",
                                    self.subtotal, @"subtotal",
                                    self.vat, @"vat",
                                    self.total, @"total",
                                    self.paid, @"paid",
                                    self.balanceDue, @"balanceDue",
                                    self.comment, @"comment",
                                    self.terms, @"terms",
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
    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Date", @"__type",
                          [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    
    NSDictionary *due = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"Date", @"__type",
                         [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    

    
    NSString *jsonString = nil;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.uniqueInvoiceNo, @"uniqueInvoiceNo",
                                    date, @"date",
                                    due, @"due",
                                    self.customerName, @"customerName",
                                    self.customerAddressLine1, @"customerAddressLine1",
                                    self.customerAddressLine2, @"customerAddressLine2",
                                    self.customerAddressLine3, @"customerAddressLine3",
                                    self.customerPostcode, @"customerPostcode",
                                    self.customerTelephone, @"customerTelephone",
                                    self.customerMobile, @"customerMobile",
                                    self.customerEmail, @"customerEmail",
                                    self.subtotal, @"subtotal",
                                    self.vat, @"vat",
                                    self.total, @"total",
                                    self.paid, @"paid",
                                    self.balanceDue, @"balanceDue",
                                    self.comment, @"comment",
                                    self.terms, @"terms",
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