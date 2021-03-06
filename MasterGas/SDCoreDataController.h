//
//  CoreDataHelper.h
//  Grocery Dude
//
//  Created by Tim Roadley on 18/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MigrationVC.h"

@interface SDCoreDataController : NSObject <UIAlertViewDelegate,NSXMLParserDelegate>


+ (id)sharedInstance;

- (NSManagedObjectContext *)masterManagedObjectContext;
- (NSManagedObjectContext *)backgroundManagedObjectContext;
- (NSManagedObjectContext *)newManagedObjectContext;


@property (strong, nonatomic) UIAlertView *confirmClose;

@property (nonatomic, readonly) NSManagedObjectContext       *parentContext;
@property (nonatomic, readonly) NSManagedObjectContext       *context;
@property (nonatomic, readonly) NSManagedObjectContext       *importContext;

@property (nonatomic, readonly) NSManagedObjectModel         *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore            *store;

@property (nonatomic, readonly) NSManagedObjectContext       *sourceContext;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *sourceCoordinator;
@property (nonatomic, readonly) NSPersistentStore            *sourceStore;

@property (nonatomic, retain) MigrationVC *migrationVC;

@property (nonatomic, retain) UIAlertView *importAlertView;

@property (nonatomic, strong) NSXMLParser *parser;

@property (nonatomic, strong) NSTimer *importTimer;

- (void)setupCoreData;
- (void)saveContext;
- (void)backgroundSaveContext;
- (BOOL)reloadStore;
- (NSURL *)applicationStoresDirectory;

- (void)saveMasterContext;
- (void)saveBackgroundContext;





- (NSURL *)applicationDocumentsDirectory;
- (NSURL *)applicationDocumentsDirectory1;

- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;




@end
