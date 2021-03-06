//
//  StockItem.h
//  MasterGas
//
//  Created by Stephen Lalor on 20/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StockItem : NSManagedObject

@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * stockCategory;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * unitPrice;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * vatRate;
@property (nonatomic, retain) NSString * discountRate;

@end
