//
//  GasWarningNoticesTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 19/04/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "GasWarningNoticesTVC.h"

#import "LACUsersHandler.h"
//#import "AppointmentTVC.h"
#import "SDCoreDataController.h"
//#import "SDTableViewCell.h"
//#import "SDAddDateViewController.h"
//#import "SDDateDetailViewController.h"
//#import "Certificate.h"
#import "SDSyncEngine.h"
//#import "AddAppointmentTVC.h"
//#import "AddCustomerTVC.h"
//#import "CustomerDetailTVC.h"
//#import "CertificateHeaderTVC.h"
#import "WarningNotice.h"
#import "GasWarningHeaderTVC.h"
#import "MainWithTwoSubtitlesCell.h"



@interface GasWarningNoticesTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation GasWarningNoticesTVC

@synthesize dateFormatter;
@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize warningNotices;

@synthesize certificateType;

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
        
      // TODO put this back in  [request setSortDescriptors:[NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
        
        [request setSortDescriptors:[NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:@"warningNoticeNumber" ascending:NO]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (companyId == %@)", SDObjectDeleted, [LACUsersHandler getCurrentCompanyId]]];
        
        self.warningNotices = [self.managedObjectContext executeFetchRequest:request error:&error];
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
    
    NSLog(@"Certificate Type: %@", self.certificateType);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkSyncStatus];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self loadRecordsFromCoreData];
        [self.tableView reloadData];
    }];
    [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
    [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *date = [self.warningNotices objectAtIndex:indexPath.row];
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
    return [self.warningNotices count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Gas Warning Notices";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = nil;
    MainWithTwoSubtitlesCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"WarningNotice"]) {
        static NSString *CellIdentifier = @"WarningNoticeCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
       WarningNotice *warningNotice = [self.warningNotices objectAtIndex:indexPath.row];
       cell.textLabel.text = warningNotice.warningNoticeNumber;
        /*
        [self.dateFormatter setDateFormat:@"d MMM yyyy"];
        NSString *detailLabel = [NSString stringWithFormat:@"%@ - %@", [self.dateFormatter stringFromDate:certificate.date], certificate.referenceNumber];
        
        cell.subtitleOneLabel.text = detailLabel;
        cell.subtitleTwoLabel.text = certificate.customerAddressLine1; */
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ViewGasWarningNotice"]) {
        GasWarningHeaderTVC *viewGasWarningNoticeTVC = segue.destinationViewController;
        viewGasWarningNoticeTVC.prefix = @"GWN";
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
     
        WarningNotice *warningNotice = [self.warningNotices objectAtIndex:indexPath.row];
        viewGasWarningNoticeTVC.managedObjectId = warningNotice.objectID;
                
        [viewGasWarningNoticeTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            [[SDSyncEngine sharedEngine] startSync];
        }];
    }

    
    /*
    if ([segue.identifier isEqualToString:@"LandlordCertSegue"]) {
        CertificateHeaderTVC *certificateHeaderTVC = segue.destinationViewController;
        certificateHeaderTVC.certificateType = self.certificateType;
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        Certificate *certificate = [self.certificates objectAtIndex:indexPath.row];
        certificateHeaderTVC.managedObjectId = certificate.objectID;
        
        [certificateHeaderTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            [[SDSyncEngine sharedEngine] startSync];
        }];
        
    } else if ([segue.identifier isEqualToString:@"ShowAddCertificateSegue"]) {
        CertificateHeaderTVC *certificateHeaderTVC = segue.destinationViewController;
        certificateHeaderTVC.certificatePrefix = @"LGSR";
        certificateHeaderTVC.certificateType = self.certificateType;
        
        [certificateHeaderTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            [[SDSyncEngine sharedEngine] startSync];
        }];
        
    } */
}

- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

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

@end
