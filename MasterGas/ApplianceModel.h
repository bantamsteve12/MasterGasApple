//
//  ApplianceModel.h
//  MasterGas
//
//  Created by Stephen Lalor on 11/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ApplianceModel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSDate * updatedAt;

@end
