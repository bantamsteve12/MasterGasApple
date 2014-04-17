//
//  JobSheetsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 04/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "JobSheetsTVC.h"

#import "SDCoreDataController.h"
#import "SDTableViewCell.h"
#import "SDAddDateViewController.h"
#import "SDDateDetailViewController.h"
#import "LACUsersHandler.h"
#import "Jobsheet.h"
//#import "SDSyncEngine.h"
#import "JobsheetHeaderTVC.h"
#import "MainWithThreeSubtitlesCell.h"
#import "NSString+Additions.h"
#import "LACHelperMethods.h"

@interface JobSheetsTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation JobSheetsTVC


@synthesize dateFormatter;
@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize jobSheets;

// tabe grouping required onjects
@synthesize sections;
@synthesize sortedDays;
@synthesize sectionDateFormatter;
@synthesize cellDateFormatter;

@synthesize customerId;
@synthesize limited;

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
   
                
        if (customerId.length > 1) {
            [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (customerId == %@)", SDObjectDeleted, self.customerId]];
        }
        else if (limited)
        {
            [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (customerId == 0)", SDObjectDeleted]];
        }
        else
        {
            [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        }

        
        
        self.jobSheets = [self.managedObjectContext executeFetchRequest:request error:&error];
        
    }];
    
    
    [self setupTitleDescriptorsAndOrdering];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    //[self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self loadRecordsFromCoreData];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadRecordsFromCoreData];
    [self setupTitleDescriptorsAndOrdering];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}



- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"AddJobsheetSegue"]) {
        
        // perform your computation to determine whether segue should occur
        BOOL segueShouldOccur = NO; // you determine this
        
        if (jobSheets.count < 3 || [LACHelperMethods fullUser]) {
            
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
                                         message:@"To add more jobsheets you need to upgrade to the pro account."
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


-(void)setupTitleDescriptorsAndOrdering
{
    // Formats the title descriptors and orders descending
    self.sections = [NSMutableDictionary dictionary];
    for (Jobsheet *jobsheet in self.jobSheets)
    {
        // Reduce certificate date components (year, month, day)
        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:jobsheet.date];
        
        // If we don't yet have an array to hold the certificates for this day, create one
        NSMutableArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            
            // Use the reduced date as dictionary key to later retrieve the event list this day
            [self.sections setObject:eventsOnThisDay forKey:dateRepresentingThisDay];
        }
        
        // Add the event to the list for this day
        [eventsOnThisDay addObject:jobsheet];
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
    
    
     [self.tableView reloadData];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    return [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}



//


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
    
    if([LACHelperMethods fullUser])
    {
    
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
    
    if ([self.entityName isEqualToString:@"Jobsheet"]) {
        static NSString *CellIdentifier = @"JobsheetCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //    Certificate *certificate = [self.certificates objectAtIndex:indexPath.row];
        
        NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
        NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        
        Jobsheet *jobsheet = [eventsOnThisDay objectAtIndex:indexPath.row];
        cell.textLabel.text = jobsheet.customerAddressName;
        
        [self.dateFormatter setDateFormat:@"d MMM yyyy"];
        NSString *detailLabel = [NSString stringWithFormat:@"%@ - %@", [self.dateFormatter stringFromDate:jobsheet.date], jobsheet.referenceNumber];
        
        NSString *siteAddress = [NSString stringWithFormat:@"%@, %@", [NSString checkForNilString:jobsheet.siteAddressLine1], [NSString checkForNilString:jobsheet.siteAddressPostcode]];
        cell.subtitleOneLabel.text = siteAddress;
        cell.subtitleTwoLabel.text = detailLabel;
        cell.subtitleThreeLabel.text = jobsheet.jobsheetNo;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"ViewJobsheetSegue"]) {
        JobsheetHeaderTVC *jobsheetHeaderTVC = segue.destinationViewController;
       // jobsheetHeaderTVC.certificateType = self.certificateType;
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
        NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        
        Jobsheet *jobsheet = [eventsOnThisDay objectAtIndex:indexPath.row];
        
        
        //  Certificate *certificate = [self.certificates objectAtIndex:indexPath.row];
        jobsheetHeaderTVC.managedObjectId = jobsheet.objectID;
        
        [jobsheetHeaderTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            [[SDSyncEngine sharedEngine] startSync];
        }];
        
    } else if ([segue.identifier isEqualToString:@"AddJobsheetSegue"]) {
        JobsheetHeaderTVC *jobsheetHeaderTVC = segue.destinationViewController;
        jobsheetHeaderTVC.certificatePrefix = @"JOB";
      //  certificateHeaderTVC.certificateType = self.certificateType;
        
        [jobsheetHeaderTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
         //   [[SDSyncEngine sharedEngine] startSync];
        }];
        
    } 
}

- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadRecordsFromCoreData];
   // [self setupTitleDescriptorsAndOrdering];
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
