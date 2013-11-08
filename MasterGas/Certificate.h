//
//  Certificate.h
//  MasterGas
//
//  Created by Stephen Lalor on 30/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Certificate : NSManagedObject

@property (nonatomic, retain) NSString * certificateNumber;
@property (nonatomic, retain) NSString * certificateType;
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
@property (nonatomic, retain) NSString * cylinderFinalConnection;
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
@property (nonatomic, retain) NSString * finalCheckECV;
@property (nonatomic, retain) NSString * finalCheckEquipotentialBonding;
@property (nonatomic, retain) NSString * finalCheckGasInstallationPipework;
@property (nonatomic, retain) NSString * finalCheckGasTightness;
@property (nonatomic, retain) NSString * finalCheckGasTightnessFinalValue;
@property (nonatomic, retain) NSString * finalCheckGasTightnessInitialValue;
@property (nonatomic, retain) NSString * lpgRegulatorLockupPressure;
@property (nonatomic, retain) NSString * lpgRegulatorOperatingPressure;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * referenceNumber;
@property (nonatomic, retain) NSString * siteAddressLine1;
@property (nonatomic, retain) NSString * siteAddressLine2;
@property (nonatomic, retain) NSString * siteAddressLine3;
@property (nonatomic, retain) NSString * siteAddressName;
@property (nonatomic, retain) NSString * siteAddressPostcode;
@property (nonatomic, retain) NSString * siteMobileNumber;
@property (nonatomic, retain) NSString * siteTelNumber;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSDate * updatedAt;

@end
