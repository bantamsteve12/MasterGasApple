//
//  Engineer.h
//  MasterGas
//
//  Created by Stephen Lalor on 20/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Engineer : NSManagedObject

@property (nonatomic, retain) NSString * active;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * engineerGSRIDNumber;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * engineerName;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * engineerSignatureFilename;

@end