//
//  SDCoreDataController.h
//  SignificantDates
//
//  Created by Chris Wagner on 5/14/12.
//

#import <Foundation/Foundation.h>

@interface SDCoreDataController : NSObject

+ (id)sharedInstance;

- (NSURL *)applicationDocumentsDirectory;

- (NSManagedObjectContext *)masterManagedObjectContext;
- (NSManagedObjectContext *)backgroundManagedObjectContext;
- (NSManagedObjectContext *)newManagedObjectContext;

// added importer


- (void)saveMasterContext;
- (void)saveBackgroundContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

- (NSURL *)applicationStoresDirectory;
- (BOOL)reloadStore;


@end


/*
 #import <Foundation/Foundation.h>
 #import <CoreData/CoreData.h>
 #import "MigrationVC.h"
 
 @interface CoreDataHelper : NSObject <UIAlertViewDelegate,NSXMLParserDelegate>
 
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
 @end
*/

