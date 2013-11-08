//
//  MileageTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 05/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "MileageTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Mileage.h"
#import "MileageDetailTVC.h"
#import "LACHelperMethods.h"

@interface MileageTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation MileageTVC

@synthesize dateFormatter;
@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize mileageRecords;

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
        
        NSLog(@"entity: %@", self.entityName);
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
      //  [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        self.mileageRecords = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.dateFormatter = [[NSDateFormatter alloc] init];
   // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self loadRecordsFromCoreData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
  //  [self checkSyncStatus];
    
   // [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self loadRecordsFromCoreData];
        [self.tableView reloadData];
   // }];
   // [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
//    [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([LACHelperMethods fullUser]) {
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *date = [self.mileageRecords objectAtIndex:indexPath.row];
        [self.managedObjectContext performBlockAndWait:^{
            if ([[date valueForKey:@"objectId"] isEqualToString:@""] || [date valueForKey:@"objectId"] == nil) {
                [self.managedObjectContext deleteObject:date];
            } else {
          //      [date setValue:[NSNumber numberWithInt:SDObjectDeleted] forKey:@"syncStatus"];
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
    else
    {
        [LACHelperMethods showBasicOKAlertMessage:@"Upgrade required" withMessage:@"You need to upgrade to a Pro account to delete"];
    }
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
    return [self.mileageRecords count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainWithTwoSubtitlesCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"Mileage"]) {
        static NSString *CellIdentifier = @"MileageCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Mileage *mileage = [self.mileageRecords objectAtIndex:indexPath.row];
        cell.textLabel.text = mileage.reference;
        [self.dateFormatter setDateFormat:@"d MMM yyyy"];
        cell.subtitleOneLabel.text = [self.dateFormatter stringFromDate:mileage.date];
        cell.subtitleTwoLabel.text = mileage.uniqueClaimNo;
    }
    
    return cell;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"AddMileageDetailSegue"]) {
        
        // perform your computation to determine whether segue should occur
        BOOL segueShouldOccur = NO; // you determine this
        
        if (mileageRecords.count < 3 || [LACHelperMethods fullUser]) {
            
            segueShouldOccur = YES;
        }
        else
        {
            
            [LACHelperMethods checkUserSubscriptionInCloud];
            
            
            if ([LACHelperMethods fullUser]) {
                segueShouldOccur = YES;
            }
            
        }
        
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Upgrade required"
                                         message:@"To add more mileage claims you need to upgrade to the pro account."
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            // prevent segue from occurring
            return NO;
        }
    }
    // by default perform the segue transition
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"MileageDetailSegue"]) {
        MileageDetailTVC *mileageDetailTVC = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        Mileage *mileage = [self.mileageRecords objectAtIndex:indexPath.row];
        mileageDetailTVC.managedObjectId = mileage.objectID;
        
        [mileageDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
       //     [[SDSyncEngine sharedEngine] startSync];
        }];
        
    }
    else if ([segue.identifier isEqualToString:@"AddMileageDetailSegue"]) {
        MileageDetailTVC *mileageDetailTVC = segue.destinationViewController;
        [mileageDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
      //      [[SDSyncEngine sharedEngine] startSync];
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
} */

@end
