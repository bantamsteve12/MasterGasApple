//
//  MileageItem.h
//  MasterGas
//
//  Created by Stephen Lalor on 11/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MileageItem : NSManagedObject

@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * finishMileage;
@property (nonatomic, retain) NSString * journeyDescription;
@property (nonatomic, retain) NSString * journeyNotes;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * startMileage;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * totalMileage;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * vehicleRegistration;
@property (nonatomic, retain) NSString * mileageClaimUniqueNo;

@end
