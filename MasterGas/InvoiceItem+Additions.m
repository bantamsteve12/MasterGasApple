//
//  InvoiceItem+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 08/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "InvoiceItem+Additions.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"


@implementation InvoiceItem (Additions)


- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.itemDescription, @"itemDescription",
                                    self.invoiceUniqueNo, @"invoiceUniqueNo",
                                    self.quantity, @"quantity",
                                    self.total, @"total",
                                    self.unitPrice, @"unitPrice",
                                    self.vat, @"vat",
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

- (NSDictionary *)JSONToEditObjectOnServer {
    NSString *jsonString = nil;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.itemDescription, @"itemDescription",
                                    self.invoiceUniqueNo, @"invoiceUniqueNo",
                                    self.quantity, @"quantity",
                                    self.total, @"total",
                                    self.unitPrice, @"unitPrice",
                                    self.vat, @"vat",
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
