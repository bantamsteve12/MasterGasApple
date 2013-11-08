//
//  Sites.h
//  MasterGas
//
//  Created by Stephen Lalor on 30/10/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sites : NSManagedObject

@property (nonatomic, retain) NSString * addressLine1;
@property (nonatomic, retain) NSString * addressLine2;
@property (nonatomic, retain) NSString * addressLine3;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * customerNo;
@property (nonatomic, retain) NSString * siteReferenceNo;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * mobileNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSDate * updatedAt;

@end
