//
//  SDSyncEngine.h
//  SignificantDates
//
//  Created by Chris Wagner on 7/1/12.
//



#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef enum {
    SDObjectSynced = 0,
    SDObjectCreated,
    SDObjectDeleted,
    SDObjectEdited,
} SDObjectSyncStatus;

@interface SDSyncEngine : NSObject

@property (atomic, readonly) BOOL syncInProgress;

+ (SDSyncEngine *)sharedEngine;

- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)startSync;

- (NSString *)dateStringForAPIUsingDate:(NSDate *)date;

@end
 

/*

//
//  StackMobSyncEngine.h
//  MasterGas
//
//  Created by Stephen Lalor on 30/04/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Parse/Parse.h>

typedef enum {
    SDObjectSynced = 0,
    SDObjectCreated,
    SDObjectDeleted,
    SDObjectEdited,
} SDObjectSyncStatus;

@interface SDSyncEngine : NSObject

@property (atomic, readonly) BOOL syncInProgress;

+ (SDSyncEngine *)sharedEngine;

- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)startSync;

- (NSString *)dateStringForAPIUsingDate:(NSDate *)date;

@end */

