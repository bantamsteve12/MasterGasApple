//
//  Mileage.h
//  MasterGas
//
//  Created by Stephen Lalor on 12/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mileage : NSManagedObject

@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * uniqueClaimNo;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * engineerName;

@end
