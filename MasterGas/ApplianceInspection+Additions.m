//
//  ApplianceInspection+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 13/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "ApplianceInspection+Additions.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"

@implementation ApplianceInspection (Additions)

- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    
    /*NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
     @"Date", @"__type",
     [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil]; */
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.applianceInspected, @"applianceInspected",
                                    self.applianceMake, @"applianceMake",
                                    self.applianceModel, @"applianceModel",
                                    self.applianceSafeToUse, @"applianceSafeToUse",
                                    self.applianceServiced, @"applianceServiced",
                                    self.applianceType, @"applianceType",
                                    self.certificateReference, @"certificateReference",
                                    self.companyId, @"companyId",
                                    self.combustion1stCO2Reading, @"combustion1stCO2Reading",
                                    self.combustion1stCOReading, @"combustion1stCOReading",
                                    self.combustion1stRatioReading,@"combustion1stRatioReading",
                                    self.combustion2ndCO2Reading, @"combustion2ndCO2Reading",
                                    self.combustion2ndCOReading, @"combustion2ndCOReading",
                                    self.combustion2ndRatioReading, @"combustion2ndRatioReading",
                                    self.combustion3rdCO2Reading, @"combustion3rdCO2Reading",
                                    self.combustion3rdCOReading, @"combustion3rdCOReading",
                                    self.combustion3rdRatioReading, @"combustion3rdRatioReading",
                                    self.engineerId, @"engineerId",
                                    self.faultDetails, @"faultDetails",
                                    self.fluePerformanceTests, @"fluePerformanceTests",
                                    self.flueType, @"flueType",
                                    self.heatInput, @"heatInput",
                                    self.landlordsAppliance, @"landlordsAppliance",
                                    self.location, @"location",
                                    self.operatingPressure, @"operatingPressure",
                                    self.remedialActionTaken, @"remedialActionTaken",
                                    self.safetyDeviceInCorrectOperation, @"safetyDeviceInCorrectOperation",
                                    self.ventilationProvision, @"ventilationProvision",
                                    self.visualConditionOfFlueSatisfactory, @"visualConditionOfFlueSatisfactory",
                                    self.warningNoticeLabelIssued, @"warningNoticeLabelIssued",
                                    self.warningNoticeNumber, @"warningNoticeNumber",
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
                                    self.applianceInspected, @"applianceInspected",
                                    self.applianceMake, @"applianceMake",
                                    self.applianceModel, @"applianceModel",
                                    self.applianceSafeToUse, @"applianceSafeToUse",
                                    self.applianceServiced, @"applianceServiced",
                                    self.applianceType, @"applianceType",
                                    self.certificateReference, @"certificateReference",
                                    self.companyId, @"companyId",
                                    self.combustion1stCO2Reading, @"combustion1stCO2Reading",
                                    self.combustion1stCOReading, @"combustion1stCOReading",
                                    self.combustion1stRatioReading,@"combustion1stRatioReading",
                                    self.combustion2ndCO2Reading, @"combustion2ndCO2Reading",
                                    self.combustion2ndCOReading, @"combustion2ndCOReading",
                                    self.combustion2ndRatioReading, @"combustion2ndRatioReading",
                                    self.combustion3rdCO2Reading, @"combustion3rdCO2Reading",
                                    self.combustion3rdCOReading, @"combustion3rdCOReading",
                                    self.combustion3rdRatioReading, @"combustion3rdRatioReading",
                                    self.engineerId, @"engineerId",
                                    self.faultDetails, @"faultDetails",
                                    self.fluePerformanceTests, @"fluePerformanceTests",
                                    self.flueType, @"flueType",
                                    self.heatInput, @"heatInput",
                                    self.landlordsAppliance, @"landlordsAppliance",
                                    self.location, @"location",
                                    self.operatingPressure, @"operatingPressure",
                                    self.remedialActionTaken, @"remedialActionTaken",
                                    self.safetyDeviceInCorrectOperation, @"safetyDeviceInCorrectOperation",
                                    self.ventilationProvision, @"ventilationProvision",
                                    self.visualConditionOfFlueSatisfactory, @"visualConditionOfFlueSatisfactory",
                                    self.warningNoticeLabelIssued, @"warningNoticeLabelIssued",
                                    self.warningNoticeNumber, @"warningNoticeNumber",
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


