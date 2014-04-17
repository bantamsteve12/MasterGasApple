//
//  CommercialGasSafetyRecordsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 19/02/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import "CommercialGasSafetyRecordsTVC.h"
#import "CertificatesTVC.h"

#import "AppointmentTVC.h"
#import "SDCoreDataController.h"

#import "GasSafetyNonDomestic.h"

// check these are required.
#import "AddAppointmentTVC.h"
#import "AddCustomerTVC.h"
#import "CustomerDetailTVC.h"

#import "CertificateHeaderTVC.h"

#import "MainWithThreeSubtitlesCell.h"
#import "NSString+Additions.h"
#import "LACHelperMethods.h"


@interface CommercialGasSafetyRecordsTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation CommercialGasSafetyRecordsTVC


@synthesize dateFormatter;
@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize certificates;

// tabe grouping required onjects
@synthesize sections;
@synthesize sortedDays;
@synthesize sectionDateFormatter;
@synthesize cellDateFormatter;

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
        
        if (self.customerId.length > 1) {
            [request setPredicate:[NSPredicate predicateWithFormat:@"(customerId == %@)", self.customerId]];
        }
        
        
        self.certificates = [self.managedObjectContext executeFetchRequest:request error:&error];
        
    }];
    
    [self setupTitleDescriptorsAndOrdering];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self loadRecordsFromCoreData];
    
    // [self setupTitleDescriptorsAndOrdering];
    
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
   
  //  self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
   // self.dateFormatter = [[NSDateFormatter alloc] init];
    // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
   // [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self loadRecordsFromCoreData];
    
    [self setupTitleDescriptorsAndOrdering];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
    //  [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
}


-(void)setupTitleDescriptorsAndOrdering
{
    // Formats the title descriptors and orders descending
    self.sections = [NSMutableDictionary dictionary];
    for (Certificate *cert in self.certificates)
    {
        // Reduce certificate date components (year, month, day)
        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:cert.date];
        
        // If we don't yet have an array to hold the certificates for this day, create one
        NSMutableArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            // Use the reduced date as dictionary key to later retrieve the event list this day
            [self.sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
        }
        
        // Add the event to the list for this day
        [eventsOnThisDay addObject:cert];
    }
    
    // Create a sorted list of days
    NSArray *unsortedDays = [self.sections allKeys];
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[unsortedDays sortedArrayUsingDescriptors:descriptors];
    
    self.sortedDays = reverseOrder;
    
    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
    [self.sectionDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    // ENDS
    
    [self.tableView reloadData];
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    return [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate
{
    // Use the user's current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:numberOfYears];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    return newDate;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([LACHelperMethods fullUser]) {
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
            NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
            NSManagedObject *date = [eventsOnThisDay objectAtIndex:indexPath.row];
            
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
    else
    {
        [LACHelperMethods showBasicOKAlertMessage:@"Upgrade required" withMessage:@"You need to upgrade to a Pro account to delete"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainWithThreeSubtitlesCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"GasSafetyNonDomestic"]) {
        static NSString *CellIdentifier = @"CertificateCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
        NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        
        GasSafetyNonDomestic *certificate = [eventsOnThisDay objectAtIndex:indexPath.row];
        cell.textLabel.text = certificate.customerAddressName;
        
        [self.dateFormatter setDateFormat:@"d MMM yyyy"];
        NSString *detailLabel = [NSString stringWithFormat:@"%@ - %@", [self.dateFormatter stringFromDate:certificate.date], certificate.referenceNumber];
        
        NSString *siteAddress = [NSString stringWithFormat:@"%@, %@", [NSString checkForNilString:certificate.siteAddressLine1], [NSString checkForNilString:certificate.siteAddressPostcode]];
        cell.subtitleOneLabel.text = siteAddress;
        cell.subtitleTwoLabel.text = detailLabel;
        cell.subtitleThreeLabel.text = certificate.certificateNumber;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"ShowCertificateSegue"]) {
        CertificateHeaderTVC *certificateHeaderTVC = segue.destinationViewController;
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
        NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        
        Certificate *certificate = [eventsOnThisDay objectAtIndex:indexPath.row];
        
        certificateHeaderTVC.managedObjectId = certificate.objectID;
        
        [certificateHeaderTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
          //  [[SDSyncEngine sharedEngine] startSync];
        }];
        
    } else if ([segue.identifier isEqualToString:@"AddCertificateSegue"]) {
        CertificateHeaderTVC *certificateHeaderTVC = segue.destinationViewController;
        certificateHeaderTVC.certificatePrefix = @"ND-GSR";
        
        [certificateHeaderTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
        }];
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ShowAddCertificateSegue"]) {
        
        // perform your computation to determine whether segue should occur
        BOOL segueShouldOccur = NO; // you determine this
        
        if (certificates.count < 3 || [LACHelperMethods fullUser]) {
            
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
                                         message:@"To add more certificates you need to upgrade to the pro account."
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

-(void)viewWillAppear:(BOOL)animated
{
    [self setupTitleDescriptorsAndOrdering];
}

@end
