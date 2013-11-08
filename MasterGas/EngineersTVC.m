//
//  EngineersTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 21/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "EngineersTVC.h"

#import "AppointmentTVC.h"
#import "SDCoreDataController.h"
#import "SDTableViewCell.h"
#import "SDAddDateViewController.h"
#import "SDDateDetailViewController.h"
#import "Engineer.h"
//#import "SDSyncEngine.h"
#import "AddAppointmentTVC.h"
#import "AddCustomerTVC.h"
#import "CustomerDetailTVC.h"
#import "CertificateHeaderTVC.h"

@interface EngineersTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation EngineersTVC

@synthesize dateFormatter;
@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize engineers;

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
                                     [NSSortDescriptor sortDescriptorWithKey:@"engineerName" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        self.engineers = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self loadRecordsFromCoreData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadRecordsFromCoreData];
    [self.tableView reloadData];
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
    return [self.engineers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"Engineer"]) {
        static NSString *CellIdentifier = @"EngineerCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Engineer *engineer = [self.engineers objectAtIndex:indexPath.row];
        cell.textLabel.text = engineer.engineerName;
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Gas Safe Reg ID: %@", engineer.engineerGSRIDNumber];
        
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"EngineerDetailSegue"]) {
      
        EngineerDetailTVC *engineerDetailTVC = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        Engineer *engineer = [self.engineers objectAtIndex:indexPath.row];
        engineerDetailTVC.managedObjectId = engineer.objectID;
        
        [engineerDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            [[SDSyncEngine sharedEngine] startSync];
        }];
        
    } else if ([segue.identifier isEqualToString:@"AddEngineerDetailSegue"]) {
      
        /*CertificateHeaderTVC *certificateHeaderTVC = segue.destinationViewController;
        
        [certificateHeaderTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            [[SDSyncEngine sharedEngine] startSync];
        }]; */
        
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
