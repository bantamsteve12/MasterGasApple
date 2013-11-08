//
//  LookupSettingsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 04/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "LookupSettingsTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"

@interface LookupSettingsTVC ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation LookupSettingsTVC


@synthesize managedObjectContext;
@synthesize entityName;
@synthesize footerDescription;
@synthesize refreshButton;
@synthesize items;
@synthesize itemIdRequired;
@synthesize delegate;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
//        [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        self.items = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    [self loadRecordsFromCoreData];
    self.title = self.titleName;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
  //  [self checkSyncStatus];
    
  //  [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self loadRecordsFromCoreData];
        [self.tableView reloadData];
   // }];
  //  [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
  //  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
  //  [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    static NSString *CellIdentifier = @"ItemCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSManagedObject *object = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = [object valueForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
            
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSManagedObject *date = [self.items objectAtIndex:indexPath.row];
            [self.managedObjectContext performBlockAndWait:^{
                if ([[date valueForKey:@"objectId"] isEqualToString:@""] || [date valueForKey:@"objectId"] == nil) {
                    [self.managedObjectContext deleteObject:date];
                } else {
                 //   [date setValue:[NSNumber numberWithInt:SDObjectDeleted] forKey:@"syncStatus"];
                }
                NSError *error = nil;
                BOOL saved = [self.managedObjectContext save:&error];
                if (!saved) {
                    NSLog(@"Error saving main context: %@", error);
                }
                
                [[SDCoreDataController sharedInstance] saveMasterContext];
                [self loadRecordsFromCoreData];
                [self.tableView reloadData];
            }];
        }
}



- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

/*
- (IBAction)refreshButtonTouched:(id)sender {
    [[SDSyncEngine sharedEngine] startSync];
}

- (void)checkSyncStatus {
    if ([[SDSyncEngine sharedEngine] syncInProgress]) {
        [self replaceRefreshButtonWithActivityIndicator];
    } else {
        [self removeActivityIndicatorFromRefreshButon];
    }
}

- (void)replaceRefreshButtonWithActivityIndicator {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityIndicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.leftBarButtonItem = activityItem;
}

- (void)removeActivityIndicatorFromRefreshButon {
    self.navigationItem.leftBarButtonItem = self.refreshButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"syncInProgress"]) {
        [self checkSyncStatus];
    }
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"EditItemSegue"]) {
        
        LookupSettingsItemTVC *lookupSettingsItemTVC = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        NSManagedObject *managedObject = [self.items objectAtIndex:indexPath.row];
        lookupSettingsItemTVC.managedObjectId = managedObject.objectID;
        lookupSettingsItemTVC.entityName = self.entityName;
        lookupSettingsItemTVC.titleName = @"Add";
        lookupSettingsItemTVC.footerDescription = self.footerDescription;
        [lookupSettingsItemTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
          //  [[SDSyncEngine sharedEngine] startSync];
        }];
        
    } else if ([segue.identifier isEqualToString:@"AddItemSegue"]) {
        
        LookupSettingsItemTVC *lookupSettingsItemTVC = segue.destinationViewController;
        lookupSettingsItemTVC.entityName = self.entityName;
        lookupSettingsItemTVC.titleName = @"Edit";
        
        lookupSettingsItemTVC.footerDescription = self.footerDescription;
        
        lookupSettingsItemTVC.itemIdRequired = self.itemIdRequired;
        
        
        [lookupSettingsItemTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
         //   [[SDSyncEngine sharedEngine] startSync];
        }];
       
        
    }
}

@end
