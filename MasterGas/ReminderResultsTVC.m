//
//  ReminderResultsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 17/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "ReminderResultsTVC.h"
#import "SDCoreDataController.h"
#import "SDTableViewCell.h"
#import "SDAddDateViewController.h"
#import "SDDateDetailViewController.h"
#import "LACUsersHandler.h"
#import "Jobsheet.h"
#import "JobsheetHeaderTVC.h"
#import "MainWithThreeSubtitlesCell.h"
#import "NSString+Additions.h"
#import "LACHelperMethods.h"
#import "SendReminderTVC.h"

#import "Certificate.h"
#import "MaintenanceServiceCheck.h"
#import "MaintenanceServiceRecord.h"

@interface ReminderResultsTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation ReminderResultsTVC


@synthesize managedObjectContext;
@synthesize refreshButton;
@synthesize reminders;
@synthesize month;
@synthesize year;


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
        
        int queryMonth = [self numberForMonth:self.month];
        int totalDaysForMonth = [self totalDaysInMonth:self.month];
        
        int selectedYear = [self.year intValue];
        int queryYear = selectedYear - 1;
       
        NSString *dateStrStart = [NSString stringWithFormat:@"%i %i %i 00:00:01 +0000", 1, queryMonth, queryYear];
      
        NSString *dateStrFinish = [NSString stringWithFormat:@"%i %i %i 23:59:59 +0000", totalDaysForMonth, queryMonth, queryYear];
        
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"d MM yyyy HH:mm:ss Z"];
        NSDate *startDate = [dateFormat dateFromString:dateStrStart];
        NSDate *endDate = [dateFormat dateFromString:dateStrFinish];
       
        
        [request setPredicate:[NSPredicate predicateWithFormat:@"date <= %@ AND date >= %@", endDate, startDate]];
    
        self.reminders = [self.managedObjectContext executeFetchRequest:request error:&error];
        
    }];
}


-(int)numberForMonth:(NSString *)selectedMonth
{
    if ([selectedMonth isEqualToString:@"January"]) {
        return 1;
    }
    else if ([selectedMonth isEqualToString:@"February"]) {
        return 2;
    }
    else if ([selectedMonth isEqualToString:@"March"]) {
        return 3;
    }
    else if ([selectedMonth isEqualToString:@"April"]) {
        return 4;
    }
    else if ([selectedMonth isEqualToString:@"May"]) {
        return 5;
    }
    else if ([selectedMonth isEqualToString:@"June"]) {
        return 6;
    }
    else if ([selectedMonth isEqualToString:@"July"]) {
        return 7;
    }
    else if ([selectedMonth isEqualToString:@"August"]) {
        return 8;
    }
    else if ([selectedMonth isEqualToString:@"September"]) {
        return 9;
    }
    else if ([selectedMonth isEqualToString:@"October"]) {
        return 10;
    }
    else if ([selectedMonth isEqualToString:@"November"]) {
        return 11;
    }
    else if ([selectedMonth isEqualToString:@"December"]) {
        return 12;
    }
    
    return 1;
}


-(int)totalDaysInMonth:(NSString *)selectedMonth
{
    if ([selectedMonth isEqualToString:@"January"]) {
        return 31;
    }
    else if ([selectedMonth isEqualToString:@"February"]) {
        return 29;
    }
    else if ([selectedMonth isEqualToString:@"March"]) {
        return 31;
    }
    else if ([selectedMonth isEqualToString:@"April"]) {
        return 30;
    }
    else if ([selectedMonth isEqualToString:@"May"]) {
        return 31;
    }
    else if ([selectedMonth isEqualToString:@"June"]) {
        return 30;
    }
    else if ([selectedMonth isEqualToString:@"July"]) {
        return 31;
    }
    else if ([selectedMonth isEqualToString:@"August"]) {
        return 31;
    }
    else if ([selectedMonth isEqualToString:@"September"]) {
        return 30;
    }
    else if ([selectedMonth isEqualToString:@"October"]) {
        return 31;
    }
    else if ([selectedMonth isEqualToString:@"November"]) {
        return 30;
    }
    else if ([selectedMonth isEqualToString:@"December"]) {
        return 31;
    }
    
    return 1;
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
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.entityName isEqualToString:@"Certificate"]) {
        return @"Landlord Gas Safety Records";
    }
    else if([self.entityName isEqualToString:@"MaintenanceServiceRecord"]) {
        return @"Maintenance / Service Records";
    }
    else if([self.entityName isEqualToString:@"MaintenanceServiceCheck"]) {
        return @"Maintenance / Service Check Records";
    }
    else
    {
        return @"";
    }
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SendReminderSegue"]) {
        SendReminderTVC *sendReminderTVC = segue.destinationViewController;
      
        
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
        if ([self.entityName isEqualToString:@"Certificate"]) {
            Certificate *certificate = [self.reminders objectAtIndex:indexPath.row];
            sendReminderTVC.certicate = certificate;
            
        }
        else if([self.entityName isEqualToString:@"MaintenanceServiceRecord"]) {
            MaintenanceServiceRecord *maintenanceServiceRecord = [self.reminders objectAtIndex:indexPath.row];
            sendReminderTVC.maintenanceServiceRecord = maintenanceServiceRecord;
        }
        else if([self.entityName isEqualToString:@"MaintenanceServiceCheck"]) {
            MaintenanceServiceCheck *maintenanceServiceCheck = [self.reminders objectAtIndex:indexPath.row];
            sendReminderTVC.maintenanceServiceCheck = maintenanceServiceCheck;
        }
    }
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reminders.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainWithThreeSubtitlesCell *cell = nil;
    static NSString *CellIdentifier = @"ReminderCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Certificate *certificate = [self.reminders objectAtIndex:indexPath.row];
    cell.textLabel.text = certificate.customerAddressName;
    cell.subtitleOneLabel.text = certificate.siteAddressLine1;
    cell.subtitleTwoLabel.text = certificate.siteAddressLine2;
    cell.subtitleThreeLabel.text = certificate.siteAddressLine3;
    cell.subtitleFourLabel.text = certificate.siteAddressPostcode;
    
    return cell;
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

@end
