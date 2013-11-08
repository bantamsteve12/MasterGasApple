//
//  Reminders.h
//  MasterGas
//
//  Created by Stephen Lalor on 16/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Reminders : NSManagedObject

@property (nonatomic, retain) NSString * reminderId;
@property (nonatomic, retain) NSString * customerId;
@property (nonatomic, retain) NSString * reminderType;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * emailSentDate;
@property (nonatomic, retain) NSDate * smsSentDate;
@property (nonatomic, retain) NSDate * letterSentDate;

@end
