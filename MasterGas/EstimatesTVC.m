//
//  EstimatesTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 13/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "EstimatesTVC.h"
#import "SDCoreDataController.h"
#import "Estimate.h"
#import "EstimateDetailTVC.h"
#import "NSString+Additions.h"
#import "LACHelperMethods.h"

@interface EstimatesTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation EstimatesTVC


@synthesize dateFormatter;
@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize estimates;
@synthesize customerId;


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
        
        
        self.estimates = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    //  [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self loadRecordsFromCoreData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadRecordsFromCoreData];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


 // also edit with this code to delete correct
 
// NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
// NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
// NSManagedObject *date = [eventsOnThisDay objectAtIndex:indexPath.row];
 
// [self.managedObjectContext performBlockAndWait:^{
// if ([[date valueForKey:@"objectId"] isEqualToString:@""] || [date valueForKey:@"objectId"] == nil) {
// [self.managedObjectContext deleteObject:date];
// }
 

 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([LACHelperMethods fullUser]) {
        
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSManagedObject *date = [self.estimates objectAtIndex:indexPath.row];
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
    return [self.estimates count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainWithThreeSubtitlesCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"Estimate"]) {
        static NSString *CellIdentifier = @"EstimateCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Estimate *estimate = [self.estimates objectAtIndex:indexPath.row];
        cell.textLabel.text = estimate.customerName;
        [self.dateFormatter setDateFormat:@"d MMM yyyy"];
        
        float invoiceTotal = [estimate.total floatValue];
        
        
        NSString *amount = [NSString stringWithFormat:@"Total: %@%@ ", [LACHelperMethods getDefaultCurrency],[NSString checkForNilString:estimate.total]];
        
        cell.subtitleOneLabel.text = amount;
        cell.subtitleTwoLabel.text = [self.dateFormatter stringFromDate:estimate.date];
        cell.subtitleThreeLabel.text = estimate.uniqueEstimateNo;
    
    }
    
    return cell;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"AddEstimateDetailSegue"]) {
        
        // perform your computation to determine whether segue should occur
        BOOL segueShouldOccur = NO; // you determine this
        
        if (estimates.count < 3 || [LACHelperMethods fullUser]) {
            
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
                                         message:@"To add more estimates and quotes you need to upgrade to the pro account."
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

    if ([segue.identifier isEqualToString:@"EstimateDetailSegue"]) {
   
        EstimateDetailTVC *estimateDetailTVC = segue.destinationViewController;
            UITableViewCell *cell = (UITableViewCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        Estimate *estimate = [self.estimates objectAtIndex:indexPath.row];
        estimateDetailTVC.managedObjectId = estimate.objectID;
        
        [estimateDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
        }];
        
    }
    // TODO change to estimate
    else if ([segue.identifier isEqualToString:@"AddEstimateDetailSegue"]) {
        EstimateDetailTVC *estimateDetailTVC = segue.destinationViewController;
        
        [estimateDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
        }];
    }
}

- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}


@end
