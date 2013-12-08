//
//  Email.h
//  MasterGas
//
//  Created by Stephen Lalor on 08/12/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Email : NSManagedObject

@property (nonatomic, retain) NSString * bccEMailAddress;
@property (nonatomic, retain) NSString * ccEmailAddress;
@property (nonatomic, retain) NSString * certificateBodyText;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * invoiceBodyText;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * estimateBodyText;

@end
