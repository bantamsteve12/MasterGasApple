//
//  AppInspectionHeaderTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 13/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "AppInspectionHeaderTVC.h"
#import "AppointmentTVC.h"
#import "SDCoreDataController.h"
#import "SDTableViewCell.h"
#import "SDAddDateViewController.h"
#import "SDDateDetailViewController.h"
#import "Certificate.h"
//#import "SDSyncEngine.h"
#import "AddAppointmentTVC.h"
#import "AddCustomerTVC.h"
#import "CustomerDetailTVC.h"
#import "CertificateHeaderTVC.h"


@interface AppInspectionHeaderTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation AppInspectionHeaderTVC


@synthesize dateFormatter;

@synthesize entityName;
@synthesize refreshButton;
@synthesize applianceInspections;
@synthesize selectedApplianceInspection;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;
@synthesize certificateNumber;

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
                                     [NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES]]];
       [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (certificateReference == %@)", SDObjectDeleted, self.certificateNumber]];
        
        self.applianceInspections = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.dateFormatter = [[NSDateFormatter alloc] init];
  //  [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self loadRecordsFromCoreData];
    
}


- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.applianceInspections.count < 1) {
        return @"Press the + button to add your first appliance";
    }
    else
    {
        return @"Press the + button to add more appliances";
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[self checkSyncStatus];
    
    //[[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self loadRecordsFromCoreData];
        [self.tableView reloadData];
  //  }];
   // [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
    //[[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
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
    return [self.applianceInspections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"ApplianceInspection"]) {
        static NSString *CellIdentifier = @"ApplianceInspectionCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        ApplianceInspection *applianceInspection = [self.applianceInspections objectAtIndex:indexPath.row];
        cell.textLabel.text = applianceInspection.location;
        NSString *detailString = [NSString stringWithFormat:@"%@ / %@", applianceInspection.applianceMake, applianceInspection.applianceModel];
        cell.detailTextLabel.text = detailString;
    }
    
    return cell;
}

NSIndexPath *_tmpIndexPath;

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      
           _tmpIndexPath = indexPath;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this appliance inspection?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        
        
    } 
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self deleteApplianceInspection];
    }
}

-(void)deleteApplianceInspection
{
    NSManagedObject *date = [self.applianceInspections objectAtIndex:_tmpIndexPath.row];
    [self.managedObjectContext performBlockAndWait:^{
        if ([[date valueForKey:@"objectId"] isEqualToString:@""] || [date valueForKey:@"objectId"] == nil) {
            [self.managedObjectContext deleteObject:date];
        } else {
            [date setValue:[NSNumber numberWithInt:SDObjectDeleted] forKey:@"syncStatus"];
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ApplianceInspectionDetailSegue"]) {
        ApplianceInspectionDetailTVC *applianceInspectionDetailTVC = segue.destinationViewController;
   
        // Store selected Person in selectedPerson property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedApplianceInspection = [self.applianceInspections objectAtIndex:indexPath.row];
        applianceInspectionDetailTVC.selectedApplianceInspection = self.selectedApplianceInspection;
        applianceInspectionDetailTVC.managedObjectContext = self.managedObjectContext;
         applianceInspectionDetailTVC.certificateNumber = self.certificateNumber;
        
        [applianceInspectionDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
          //  [[SDSyncEngine sharedEngine] startSync];
        }];
    }
    else if ([segue.identifier isEqualToString:@"AddApplianceInspectionDetailSegue"]) {
    
        ApplianceInspectionDetailTVC *applianceInspectionDetailTVC = segue.destinationViewController;
        applianceInspectionDetailTVC.managedObjectContext = managedObjectContext;
        applianceInspectionDetailTVC.certificateNumber = self.certificateNumber;
        
        [applianceInspectionDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
           // [[SDSyncEngine sharedEngine] startSync];
        }];

    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"AddApplianceInspectionDetailSegue"]) {
        // perform your computation to determine whether segue should occur
        
        BOOL segueShouldOccur = NO; // you determine this
        
        if (applianceInspections.count < 6) {
            segueShouldOccur = YES;
        }
        
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"6 Max Appliances Reached"
                                         message:@"A maximum of 6 appliance inspections can be entered on to a Gas Safety Record."
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



- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

- (IBAction)refreshButtonTouched:(id)sender {
 //[[SDSyncEngine sharedEngine] startSync];
}

/*
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
