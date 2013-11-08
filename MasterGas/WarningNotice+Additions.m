//
//  WarningNotice+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 22/04/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "WarningNotice+Additions.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"


@implementation WarningNotice (Additions)


- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    
  /*
    NSDictionary *engSignoffDate = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"Date", @"__type",
                                    [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.engineerSignoffDate], @"iso" , nil];
    
    NSDictionary *certificateDate = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"Date", @"__type",
                                     [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    
    NSDictionary *customerSignoffDate = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"Date", @"__type",
                                         [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.customerSignoffDate], @"iso" , nil]; */
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.referenceNumber, @"referenceNumber",
                                    self.warningNoticeNumber, @"warningNoticeNumber",
                                    self.companyId, @"companyId",
                                    self.engineerId, @"engineerId",
                                    self.customerAddressName, @"customerAddressName",
                                    self.customerAddressLine1, @"customerAddressLine1",
                                    self.customerAddressLine2, @"customerAddressLine2",
                                    self.customerAddressLine3, @"customerAddressLine3",
                                    self.customerPostcode, @"customerPostcode",
                                    self.customerPosition, @"customerPosition",
                                    self.customerMobileNumber, @"customerMobileNumber",
                                    self.customerTelNumber, @"customerTelNumber",
                                    nil];
    
  /*  NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.referenceNumber, @"referenceNumber",
                                    self.warningNoticeNumber, @"warningNoticeNumber",
                                    self.companyId, @"companyId",
                                    self.engineerId, @"engineerId",
                                    certificateDate, @"date",
                                    self.customerAddressName, @"customerAddressName",
                                    self.customerAddressLine1, @"customerAddressLine1",
                                    self.customerAddressLine2, @"customerAddressLine2",
                                    self.customerAddressLine3, @"customerAddressLine3",
                                    self.customerPostcode, @"customerPostcode",
                                    self.customerSignoffName, @"customerSignoffName",
                                    self.customerPosition, @"customerPosition",
                                    self.customerSignatureFilename, @"customerSignatureFilename",
                                    customerSignoffDate, @"customerSignoffDate",
                                    self.customerTelNumber, @"customerTelNumber",
                                    self.customerMobileNumber, @"customerMobileNumber",
                                    self.siteAddressName, @"siteAddressName",
                                    self.siteAddressLine1, @"siteAddressLine1",
                                    self.siteAddressLine2, @"siteAddressLine2",
                                    self.siteAddressLine3, @"siteAddressLine3",
                                    self.siteAddressPostcode, @"siteAddressPostcode",
                                    self.siteTelNumber, @"siteTelNumber",
                                    self.siteMobileNumber, @"siteMobileNumber",
                                    self.engineerSignoffTradingTitle, @"engineerSignoffTradingTitle",
                                    self.engineerSignoffAddressLine1, @"engineerSignoffAddressLine1",
                                    self.engineerSignoffAddressLine2, @"engineerSignoffAddressLine2",
                                    self.engineerSignoffAddressLine3, @"engineerSignoffAddressLine3",
                                    self.engineerSignoffPostcode, @"engineerSignoffPostcode",
                                    self.engineerSignoffTelNumber, @"engineerSignoffTelNumber",
                                    self.engineerSignoffMobileNumber, @"engineerSignoffMobileNumber",
                                    self.engineerSignoffCompanyGasSafeRegNumber, @"engineerSignoffCompanyGasSafeRegNumber",
                                    self.engineerSignoffEngineerName, @"engineerSignoffEngineerName",
                                    self.engineerSignoffEngineerIDCardRegNumber, @"engineerSignoffEngineerIDCardRegNumber",
                                    engSignoffDate, @"engineerSignoffDate",
                                    self.engineerSignatureFilename, @"engineerSignatureFilename",
                                    self.finalCheckECV, @"finalCheckECV",
                                    self.finalCheckGasInstallationPipework, @"finalCheckGasInstallationPipework",
                                    self.finalCheckGasTightness, @"finalCheckGasTightness",
                                    self.finalCheckEquipotentialBonding, @"finalCheckEquipotentialBonding",
                                    self.finalCheckGasTightnessInitialValue, @"finalCheckGasTightnessInitialValue",
                                    self.finalCheckGasTightnessFinalValue, @"finalCheckGasTightnessFinalValue",
                                    self.cylinderFinalConnection, @"cylinderFinalConnection",
                                    self.lpgRegulatorOperatingPressure, @"lpgRegulatorOperatingPressure",
                                    self.lpgRegulatorLockupPressure, @"lpgRegulatorLockupPressure",
                                    nil]; */
    
    
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
                                    self.referenceNumber, @"referenceNumber",
                                    self.warningNoticeNumber, @"warningNoticeNumber",
                                    self.companyId, @"companyId",
                                    self.engineerId, @"engineerId",
                                    self.customerAddressName, @"customerAddressName",
                                    self.customerAddressLine1, @"customerAddressLine1",
                                    self.customerAddressLine2, @"customerAddressLine2",
                                    self.customerAddressLine3, @"customerAddressLine3",
                                    self.customerPostcode, @"customerPostcode",
                                    self.customerPosition, @"customerPosition",
                                    self.customerMobileNumber, @"customerMobileNumber",
                                    self.customerTelNumber, @"customerTelNumber",
                                    self.siteAddressLine1, @"siteAddressLine1",
                                    self.siteAddressLine2, @"siteAddressLine2",
                                    self.siteAddressLine3, @"siteAddressLine3",
                                    self.siteAddressPostcode, @"siteAddressPostcode",
                                    self.siteMobileNumber, @"siteMobileNumber",
                                    self.siteTelNumber, @"siteTelNumber",
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
