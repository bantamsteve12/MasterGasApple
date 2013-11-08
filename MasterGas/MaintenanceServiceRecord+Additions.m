//
//  MaintenanceServiceRecord+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 17/03/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "MaintenanceServiceRecord+Additions.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"


@implementation MaintenanceServiceRecord (Additions)


- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    
    
    NSDictionary *engSignoffDate = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"Date", @"__type",
                                    [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.engineerSignoffDate], @"iso" , nil];
    
    NSDictionary *recordDate = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"Date", @"__type",
                                     [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    
    NSDictionary *customerSignoffDate = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"Date", @"__type",
                                         [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.customerSignoffDate], @"iso" , nil];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    
                                    self.companyId, @"companyId",
                                    self.engineerId, @"engineerId",
                                    recordDate, @"date",
                                    self.jobType, @"jobType",
                                    self.uniqueSerialNumber, @"uniqueSerialNumber",
                                    self.reference, @"reference",
                                    self.actionRemedialWork, @"actionRemedialWork",
                                    self.additionalNotes, @"additionalNotes",
                                    self.applianceLocation, @"applianceLocation",
                                    self.applianceType, @"applianceType",
                                    self.applianceMake, @"applianceMake",
                                    self.applianceModel, @"applianceModel",
                                    self.applianceSerialNumber, @"applianceSerialNumber",
                                    self.applianceBurnerMake, @"applianceBurnerMake",
                                    self.applianceBurnerModel, @"applianceBurnerModel",
                                    self.prelimFlue, @"prelimFlue",
                                    self.prelimVentilationSize, @"prelimVentilationSize",
                                    self.customerAddressName, @"customerAddressName",
                                    self.customerAddressLine1, @"customerAddressLine1",
                                    self.customerAddressLine2, @"customerAddressLine2",
                                    self.customerAddressLine3, @"customerAddressLine3",
                                    self.customerPostcode, @"customerPostcode",
                                    self.customerTelNumber, @"customerTelNumber",
                                    self.customerMobileNumber, @"customerMobileNumber",
                                    self.customerEmail, @"customerEmail",
                                    self.siteAddressName, @"siteAddressName",
                                    self.siteAddressLine1, @"siteAddressLine1",
                                    self.siteAddressLine2, @"siteAddressLine2",
                                    self.siteAddressLine3, @"siteAddressLine3",
                                    self.siteAddressPostcode, @"siteAddressPostcode",
                                    self.siteTelNumber, @"siteTelNumber",
                                    self.siteMobileNumber, @"siteMobileNumber",
                                    self.prelimWaterFuelSound, @"prelimWaterFuelSound",
                                    self.prelimElectricallyFused, @"prelimElectricallyFused",
                                    self.prelimValvingArrangements, @"prelimValvingArrangements",
                                    self.prelimIsolationAvailable, @"prelimIsolationAvailable",
                                    self.prelimBoilerRoomClear, @"prelimBoilerRoomClear",
                                    self.serviceHeatExchanger, @"serviceHeatExchanger",
                                    self.serviceIgnition, @"serviceIgnition",
                                    self.serviceFan, @"serviceFan",
                                    self.serviceSafetyDevice, @"serviceSafetyDevice",
                                    self.serviceControlBox, @"serviceControlBox",
                                    self.serviceBurnerPilot, @"serviceBurnerPilot",
                                    self.serviceFuelPressureType, @"serviceFuelPressureType",
                                    self.serviceBurnerWashedCleaned, @"serviceBurnerWashedCleaned",
                                    self.servicePilotAssembley, @"servicePilotAssembley",
                                    self.serviceIgnitionSystemCleaned, @"serviceIgnitionSystemCleaned",
                                    self.serviceBurnerFanAirwaysCleaned, @"serviceBurnerFanAirwaysCleaned",
                                    self.serviceHeatExchangerFluewaysClean, @"serviceHeatExchangerFluewaysClean",
                                    self.serviceFuelElectricalSupplySound, @"serviceFuelElectricalSupplySound",
                                    self.serviceInterlocksInPlace, @"serviceInterlocksInPlace",
                                    self.faults, @"faults",
                                    self.warningLabelIssued, @"warningLabelIssued",
                                    self.warningAdviceNumber, @"warningAdviceNumber",
                                    self.sparesRequired, @"sparesRequired",
                                    self.customerSignoffName, @"customerSignoffName",
                                    self.customerSignatureFilename, @"customerSignatureFilename",
                                    self.customerPosition, @"customerPosition",
                                    self.engineerSignatureFilename, @"engineerSignatureFilename",
                                    self.engineerSignoffAddressLine1, @"engineerSignoffAddressLine1",
                                    self.engineerSignoffAddressLine2, @"engineerSignoffAddressLine2",
                                    self.engineerSignoffAddressLine3, @"engineerSignoffAddressLine3",
                                    self.engineerSignoffCompanyGasSafeRegNumber, @"engineerSignoffCompanyGasSafeRegNumber",
                                    self.engineerSignoffEngineerIDCardRegNumber, @"engineerSignoffEngineerIDCardRegNumber",
                                    self.engineerSignoffEngineerName, @"engineerSignoffEngineerName",
                                    self.engineerSignoffMobileNumber, @"engineerSignoffMobileNumber",
                                    self.engineerSignoffPostcode, @"engineerSignoffPostcode",
                                    self.engineerSignoffTelNumber, @"engineerSignoffTelNumber",
                                    self.engineerSignoffTradingTitle, @"engineerSignoffTradingTitle",
                                    customerSignoffDate, @"customerSignoffDate",
                                    engSignoffDate, @"engineerSignoffDate",
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
    
    
    
    NSDictionary *engSignoffDate = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"Date", @"__type",
                                    [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.engineerSignoffDate], @"iso" , nil];
    
    NSDictionary *recordDate = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Date", @"__type",
                                [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    
    NSDictionary *customerSignoffDate = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"Date", @"__type",
                                         [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.customerSignoffDate], @"iso" , nil];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.companyId, @"companyId",
                                    self.engineerId, @"engineerId",
                                    recordDate, @"date",
                                    self.uniqueSerialNumber, @"uniqueSerialNumber",
                                    self.reference, @"reference",
                                    self.jobType, @"jobType",
                                    self.additionalNotes, @"additionalNotes",
                                    self.applianceMake, @"applianceMake",
                                    self.applianceModel, @"applianceModel",
                                    self.applianceLocation, @"applianceLocation",
                                    self.applianceType, @"applianceType",
                                    self.applianceSerialNumber, @"applianceSerialNumber",
                                    self.applianceBurnerMake, @"applianceBurnerMake",
                                    self.applianceBurnerModel, @"applianceBurnerModel",
                                    self.customerAddressName, @"customerAddressName",
                                    self.customerAddressLine1, @"customerAddressLine1",
                                    self.customerAddressLine2, @"customerAddressLine2",
                                    self.customerAddressLine3, @"customerAddressLine3",
                                    self.customerPostcode, @"customerPostcode",
                                    self.customerTelNumber, @"customerTelNumber",
                                    self.customerMobileNumber, @"customerMobileNumber",
                                    self.customerEmail, @"customerEmail",
                                    self.prelimFlue, @"prelimFlue",
                                    self.prelimVentilationSize, @"prelimVentilationSize",
                                    self.siteAddressName, @"siteAddressName",
                                    self.siteAddressLine1, @"siteAddressLine1",
                                    self.siteAddressLine2, @"siteAddressLine2",
                                    self.siteAddressLine3, @"siteAddressLine3",
                                    self.siteAddressPostcode, @"siteAddressPostcode",
                                    self.siteTelNumber, @"siteTelNumber",
                                    self.siteMobileNumber, @"siteMobileNumber",
                                    self.prelimWaterFuelSound, @"prelimWaterFuelSound",
                                    self.prelimElectricallyFused, @"prelimElectricallyFused",
                                    self.prelimValvingArrangements, @"prelimValvingArrangements",
                                    self.prelimIsolationAvailable, @"prelimIsolationAvailable",
                                    self.prelimBoilerRoomClear, @"prelimBoilerRoomClear",
                                    self.serviceHeatExchanger, @"serviceHeatExchanger",
                                    self.serviceIgnition, @"serviceIgnition",
                                    self.serviceFan, @"serviceFan",
                                    self.serviceSafetyDevice, @"serviceSafetyDevice",
                                    self.serviceControlBox, @"serviceControlBox",
                                    self.serviceBurnerPilot, @"serviceBurnerPilot",
                                    self.serviceFuelPressureType, @"serviceFuelPressureType",
                                    self.serviceBurnerWashedCleaned, @"serviceBurnerWashedCleaned",
                                    self.servicePilotAssembley, @"servicePilotAssembley",
                                    self.serviceIgnitionSystemCleaned, @"serviceIgnitionSystemCleaned",
                                    self.serviceBurnerFanAirwaysCleaned, @"serviceBurnerFanAirwaysCleaned",
                                    self.serviceHeatExchangerFluewaysClean, @"serviceHeatExchangerFluewaysClean",
                                    self.serviceFuelElectricalSupplySound, @"serviceFuelElectricalSupplySound",
                                    self.serviceInterlocksInPlace, @"serviceInterlocksInPlace",
                                    self.faults, @"faults",
                                    self.actionRemedialWork, @"actionRemedialWork",
                                    self.warningLabelIssued, @"warningLabelIssued",
                                    self.warningAdviceNumber, @"warningAdviceNumber",
                                    self.sparesRequired, @"sparesRequired",
                                    self.customerSignoffName, @"customerSignoffName",
                                    self.customerSignatureFilename, @"customerSignatureFilename",
                                    self.customerPosition, @"customerPosition",
                                    self.engineerSignatureFilename, @"engineerSignatureFilename",
                                    self.engineerSignoffAddressLine1, @"engineerSignoffAddressLine1",
                                    self.engineerSignoffAddressLine2, @"engineerSignoffAddressLine2",
                                    self.engineerSignoffAddressLine3, @"engineerSignoffAddressLine3",
                                    self.engineerSignoffCompanyGasSafeRegNumber, @"engineerSignoffCompanyGasSafeRegNumber",
                                    self.engineerSignoffEngineerIDCardRegNumber, @"engineerSignoffEngineerIDCardRegNumber",
                                    self.engineerSignoffEngineerName, @"engineerSignoffEngineerName",
                                    self.engineerSignoffMobileNumber, @"engineerSignoffMobileNumber",
                                    self.engineerSignoffPostcode, @"engineerSignoffPostcode",
                                    self.engineerSignoffTelNumber, @"engineerSignoffTelNumber",
                                    self.engineerSignoffTradingTitle, @"engineerSignoffTradingTitle",
                                    engSignoffDate, @"engineerSignoffDate",
                                    customerSignoffDate, @"customerSignoffDate",
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