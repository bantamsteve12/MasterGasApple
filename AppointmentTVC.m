//
//  AppointmentTVC.m
//  SignificantDates
//
//  Created by Stephen Lalor on 29/11/2012.
//
//

#import "AppointmentTVC.h"
#import "SDCoreDataController.h"
#import "SDTableViewCell.h"
#import "SDAddDateViewController.h"
#import "SDDateDetailViewController.h"
#import "Appointment.h"
#import "SDSyncEngine.h"

#import "AddAppointmentTVC.h"
#import "MainWithThreeSubtitlesCell.h"


@interface AppointmentTVC ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end


@implementation AppointmentTVC

@synthesize dateFormatter;
@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize appointments;
@synthesize viewSelectionSegment;
@synthesize selectedAppointment;
@synthesize selectedSegmentIndex;

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


- (IBAction)dateSelectionChanged:(UISegmentedControl *)sender {
   
    /*for (int i=0; i<[sender.subviews count]; i++)
    {
        if ([[sender.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor greenColor]; //your requiremnent color here
            [[sender.subviews objectAtIndex:i] setTintColor:tintcolor];
            sender.momentary = YES;
            break;
        }
    } */

}

-(IBAction)tableSelectionSegment:(id)sender
{
    switch (self.viewSelectionSegment.selectedSegmentIndex) {
        case 0:
            self.selectedSegmentIndex = 0;
            NSLog(@"selection 0");
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            break;
        case 1:
            self.selectedSegmentIndex = 1;
            NSLog(@"selection 1");
         //   [self setupFetchedResultsController];
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            break;
        case 2:
            self.selectedSegmentIndex = 2;
            NSLog(@"selection 2");
            //   [self setupFetchedResultsController];
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            break;
        case 3:
            self.selectedSegmentIndex = 3;
            NSLog(@"selection 3");
            //   [self setupFetchedResultsController];
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}



- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
        
            
        if (customerId.length > 1) {
            [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (customerId == %@)", SDObjectDeleted, self.customerId]];
        }
        else if (limited)
        {
            [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (customerId == 0)", SDObjectDeleted]];
        }
        else
        {
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
            [components setHour:0];
            [components setMinute:0];
            [components setSecond:0];
            //create a date with these components
            NSDate *startDate = [calendar dateFromComponents:components];
            
            [components setHour:23];
            [components setMinute:59];
            [components setSecond:59];
            NSDate *endDate = [calendar dateFromComponents:components];
            
            switch (self.selectedSegmentIndex) {
            case 0: // Everything before today?
                   [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (date < %@)", SDObjectDeleted, startDate]];
                    break;
                case 1: // ALL
                    [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d)", SDObjectDeleted]];
                    break;
                case 2:
                {// TODAY
                    [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (date >= %@) AND (date <= %@)", SDObjectDeleted, startDate, endDate]];
                    break;
                }
                case 3: // All Future
                     [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (date > %@)", SDObjectDeleted, endDate]];
                    break;
                default:
                [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
                    break;

            }
        }
        
        self.appointments = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.dateFormatter = [[NSDateFormatter alloc] init];
   // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateFormat:@" HH:mm - E d MMMM yyyy"];
    
    self.selectedSegmentIndex = 2;
    
    [self loadRecordsFromCoreData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
  //  [self checkSyncStatus];
    
  /*  [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self loadRecordsFromCoreData];
        [self.tableView reloadData];
    }];
    [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil]; */
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
   
    
   //TODO: [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
   //TODO: [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
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
              
        NSManagedObject *date = [self.appointments objectAtIndex:indexPath.row];
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
    return [self.appointments count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (limited) {
            return @"Appointments History";
        }
        else
        {
        
            if (self.selectedSegmentIndex == 0) {
                return @"Past Appointments";
            }
            else if (self.selectedSegmentIndex == 1)
            {
                return @"All Appointments";
            }
            else if (self.selectedSegmentIndex == 2)
            {
                return @"Today's Appointments";
            }
            else if (self.selectedSegmentIndex == 3)
            {
                return @"Future Appointments";
            }
        }
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainWithThreeSubtitlesCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"Appointment"]) {
        static NSString *CellIdentifier = @"AppointmentCell";
       
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Appointment *appointment = [self.appointments objectAtIndex:indexPath.row];
        cell.textLabel.text = appointment.name;
        cell.subtitleOneLabel.text = [self.dateFormatter stringFromDate:appointment.date];
        cell.subtitleTwoLabel.text = appointment.callType;
        cell.subtitleThreeLabel.text = [NSString stringWithFormat:@"%@, %@", appointment.addressLine1, appointment.postcode];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowAppointmentDetailSegue"]) {
        
        AddAppointmentTVC *addAppointmentTVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Appointment *appointment = [self.appointments objectAtIndex:indexPath.row];
        addAppointmentTVC.existingAppointment = appointment;
        
        [addAppointmentTVC setAddAppointmentCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
           // [[SDSyncEngine sharedEngine] startSync];
        }];

        
    } else if ([segue.identifier isEqualToString:@"ShowAddAppointmentSegue"]) {
        AddAppointmentTVC *addAppointmentTVC = segue.destinationViewController;
        [addAppointmentTVC setAddAppointmentCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
          //  [[SDSyncEngine sharedEngine] startSync];
        }];
        
    }
}



- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

- (IBAction)refreshButtonTouched:(id)sender {
   //}| [[SDSyncEngine sharedEngine] startSync];
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
}
 */

@end
