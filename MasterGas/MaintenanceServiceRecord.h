//
//  MaintenanceServiceRecord.h
//  MasterGas
//
//  Created by Stephen Lalor on 02/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MaintenanceServiceRecord : NSManagedObject

@property (nonatomic, retain) NSString * actionRemedialWork;
@property (nonatomic, retain) NSString * additionalNotes;
@property (nonatomic, retain) NSString * applianceBurnerMake;
@property (nonatomic, retain) NSString * applianceBurnerModel;
@property (nonatomic, retain) NSString * applianceLocation;
@property (nonatomic, retain) NSString * applianceMake;
@property (nonatomic, retain) NSString * applianceModel;
@property (nonatomic, retain) NSString * applianceSerialNumber;
@property (nonatomic, retain) NSString * applianceType;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * customerAddressLine1;
@property (nonatomic, retain) NSString * customerAddressLine2;
@property (nonatomic, retain) NSString * customerAddressLine3;
@property (nonatomic, retain) NSString * customerAddressName;
@property (nonatomic, retain) NSString * customerEmail;
@property (nonatomic, retain) NSString * customerId;
@property (nonatomic, retain) NSString * customerMobileNumber;
@property (nonatomic, retain) NSString * customerPosition;
@property (nonatomic, retain) NSString * customerPostcode;
@property (nonatomic, retain) NSString * customerSignatureFilename;
@property (nonatomic, retain) NSDate * customerSignoffDate;
@property (nonatomic, retain) NSString * customerSignoffName;
@property (nonatomic, retain) NSString * customerTelNumber;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * engineerSignatureFilename;
@property (nonatomic, retain) NSString * engineerSignoffAddressLine1;
@property (nonatomic, retain) NSString * engineerSignoffAddressLine2;
@property (nonatomic, retain) NSString * engineerSignoffAddressLine3;
@property (nonatomic, retain) NSString * engineerSignoffCompanyGasSafeRegNumber;
@property (nonatomic, retain) NSDate * engineerSignoffDate;
@property (nonatomic, retain) NSString * engineerSignoffEngineerIDCardRegNumber;
@property (nonatomic, retain) NSString * engineerSignoffEngineerName;
@property (nonatomic, retain) NSString * engineerSignoffMobileNumber;
@property (nonatomic, retain) NSString * engineerSignoffPostcode;
@property (nonatomic, retain) NSString * engineerSignoffTelNumber;
@property (nonatomic, retain) NSString * engineerSignoffTradingTitle;
@property (nonatomic, retain) NSString * faults;
@property (nonatomic, retain) NSString * gasTightnessCarriedOut;
@property (nonatomic, retain) NSString * gasTightnessResult;
@property (nonatomic, retain) NSString * jobType;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * prelimBoilerRoomClear;
@property (nonatomic, retain) NSString * prelimElectricallyFused;
@property (nonatomic, retain) NSString * prelimFlue;
@property (nonatomic, retain) NSString * prelimIsolationAvailable;
@property (nonatomic, retain) NSString * prelimValvingArrangements;
@property (nonatomic, retain) NSString * prelimVentilationSize;
@property (nonatomic, retain) NSString * prelimWaterFuelSound;
@property (nonatomic, retain) NSString * recordType;
@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) NSString * serviceBurnerFanAirwaysCleaned;
@property (nonatomic, retain) NSString * serviceBurnerPilot;
@property (nonatomic, retain) NSString * serviceBurnerWashedCleaned;
@property (nonatomic, retain) NSString * serviceControlBox;
@property (nonatomic, retain) NSString * serviceFan;
@property (nonatomic, retain) NSString * serviceFuelElectricalSupplySound;
@property (nonatomic, retain) NSString * serviceFuelPressureType;
@property (nonatomic, retain) NSString * serviceGasValve;
@property (nonatomic, retain) NSString * serviceHeatExchanger;
@property (nonatomic, retain) NSString * serviceHeatExchangerFluewaysClean;
@property (nonatomic, retain) NSString * serviceIgnition;
@property (nonatomic, retain) NSString * serviceIgnitionSystemCleaned;
@property (nonatomic, retain) NSString * serviceInterlocksInPlace;
@property (nonatomic, retain) NSString * servicePilotAssembley;
@property (nonatomic, retain) NSString * serviceSafetyDevice;
@property (nonatomic, retain) NSString * siteAddressLine1;
@property (nonatomic, retain) NSString * siteAddressLine2;
@property (nonatomic, retain) NSString * siteAddressLine3;
@property (nonatomic, retain) NSString * siteAddressName;
@property (nonatomic, retain) NSString * siteAddressPostcode;
@property (nonatomic, retain) NSString * siteMobileNumber;
@property (nonatomic, retain) NSString * siteTelNumber;
@property (nonatomic, retain) NSString * sparesRequired;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * uniqueSerialNumber;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * warningAdviceNumber;
@property (nonatomic, retain) NSString * warningLabelIssued;
@property (nonatomic, retain) NSString * combustion1stCO2Reading;
@property (nonatomic, retain) NSString * combustion2ndCO2Reading;
@property (nonatomic, retain) NSString * combustion3rdCO2Reading;
@property (nonatomic, retain) NSString * combustion1stCOReading;
@property (nonatomic, retain) NSString * combustion2ndCOReading;
@property (nonatomic, retain) NSString * combustion3rdCOReading;
@property (nonatomic, retain) NSString * combustion1stRatioReading;
@property (nonatomic, retain) NSString * combustion2ndRatioReading;
@property (nonatomic, retain) NSString * combustion3rdRatioReading;

@end
