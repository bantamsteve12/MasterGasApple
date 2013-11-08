//
//  Appointment.h
//  MasterGas
//
//  Created by Stephen Lalor on 11/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Appointment : NSManagedObject

@property (nonatomic, retain) NSString * addressLine1;
@property (nonatomic, retain) NSString * addressLine2;
@property (nonatomic, retain) NSString * addressLine3;
@property (nonatomic, retain) NSString * callType;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * mobileNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * customerId;

@end
