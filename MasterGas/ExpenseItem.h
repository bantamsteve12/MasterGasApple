//
//  ExpenseItem.h
//  MasterGas
//
//  Created by Stephen Lalor on 10/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ExpenseItem : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * expenseUniqueReference;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * supplier;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * totalAmount;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * vatAmount;
@property (nonatomic, retain) NSString * subTotalAmount;
@property (nonatomic, retain) NSString * supplierId;

@end
