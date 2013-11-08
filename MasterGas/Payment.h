//
//  Payment.h
//  MasterGas
//
//  Created by Stephen Lalor on 02/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Payment : NSManagedObject

@property (nonatomic, retain) NSString * amount;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * invoiceNo;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * paymentId;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * customerId;

@end
