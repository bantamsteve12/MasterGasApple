#import "Company+Additions.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"

@implementation Company (Additions)


- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
      
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.companyName, @"companyName",
                                    self.companyAddressLine1, @"companyAddressLine1",
                                    self.companyAddressLine2, @"companyAddressLine2",
                                    self.companyAddressLine3, @"companyAddressLine3",
                                    self.companyPostcode, @"companyPostcode",
                                    self.companyTelNumber, @"companyTelNumber",
                                    self.companyMobileNumber, @"companyMobileNumber",
                                    self.companyGSRNumber, @"companyGSRNumber",
                                    self.companyVATNumber, @"companyVATNumber",
                                    self.companyEmailAddress, @"companyEmailAddress",
                                    self.companyId, @"companyId",
                                    self.engineerId, @"engineerId",
                                    self.username, @"username",
                                    self.password, @"password",
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
                                    self.companyName, @"companyName",
                                    self.companyAddressLine1, @"companyAddressLine1",
                                    self.companyAddressLine2, @"companyAddressLine2",
                                    self.companyAddressLine3, @"companyAddressLine3",
                                    self.companyPostcode, @"companyPostcode",
                                    self.companyTelNumber, @"companyTelNumber",
                                    self.companyMobileNumber, @"companyMobileNumber",
                                    self.companyGSRNumber, @"companyGSRNumber",
                                    self.companyVATNumber, @"companyVATNumber",
                                    self.companyEmailAddress, @"companyEmailAddress",
                                    self.companyId, @"companyId",
                                    self.engineerId, @"engineerId",
                                    self.username, @"username",
                                    self.password, @"password",
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