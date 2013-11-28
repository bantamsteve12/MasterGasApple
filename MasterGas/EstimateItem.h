//
//  EstimateItem.h
//  MasterGas
//
//  Created by Stephen Lalor on 13/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EstimateItem : NSManagedObject

@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * discountRate;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * estimateNo;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * total;
@property (nonatomic, retain) NSString * unitPrice;
@property (nonatomic, retain) NSString * updatedAt;
@property (nonatomic, retain) NSString * vat;
@property (nonatomic, retain) NSString * vatAmount;

@end
