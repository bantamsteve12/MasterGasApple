//
//  Company.h
//  MasterGas
//
//  Created by Stephen Lalor on 30/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * companyAddressLine1;
@property (nonatomic, retain) NSString * companyAddressLine2;
@property (nonatomic, retain) NSString * companyAddressLine3;
@property (nonatomic, retain) NSString * companyCompaniesHouseRegNumber;
@property (nonatomic, retain) NSString * companyEmailAddress;
@property (nonatomic, retain) NSString * companyGSRNumber;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSString * companyMobileNumber;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * companyPostcode;
@property (nonatomic, retain) NSString * companyTelNumber;
@property (nonatomic, retain) NSString * companyVATNumber;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * standardCompanyVatAmount;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * defaultCurrency;

@end
