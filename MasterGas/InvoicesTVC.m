//
//  InvoicesTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 08/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "InvoicesTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Invoice.h"
#import "InvoiceDetailTVC.h"
#import "NSString+Additions.h"
#import "LACHelperMethods.h"

@interface InvoicesTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation InvoicesTVC

@synthesize dateFormatter;
@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize invoices;
@synthesize customerId;
@synthesize limited;
@synthesize outstanding;

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
               [request setPredicate:[NSPredicate predicateWithFormat:@"(customerId == %@)", self.customerId]];
        }
        else if (limited)
        {
          [request setPredicate:[NSPredicate predicateWithFormat:@"(customerId == 0)"]];
        }
        else if (outstanding)
        {
            [request setPredicate:[NSPredicate predicateWithFormat:@"(balanceDue != %@)", @"0.00"]];
        }
        
        self.invoices = [self.managedObjectContext executeFetchRequest:request error:&error];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
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
            NSManagedObject *date = [self.invoices objectAtIndex:indexPath.row];
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
    return [self.invoices count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainWithThreeSubtitlesCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"Invoice"]) {
        static NSString *CellIdentifier = @"InvoiceCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        Invoice *invoice = [self.invoices objectAtIndex:indexPath.row];
        cell.textLabel.text = invoice.customerName;
        [self.dateFormatter setDateFormat:@"d MMM yyyy"];
       
        float invoiceTotal = [invoice.total floatValue];
        float invoicePaid = [invoice.paid floatValue];
        float outstandingAmount = invoiceTotal - invoicePaid;
        
        
        NSString *amount = [NSString stringWithFormat:@"Total: %@%@ / Outstanding: %@%.2f ", [LACHelperMethods getDefaultCurrency],[NSString checkForNilString:invoice.total], [LACHelperMethods getDefaultCurrency], outstandingAmount];
        
        cell.subtitleOneLabel.text = amount;
        cell.subtitleTwoLabel.text = [self.dateFormatter stringFromDate:invoice.date];
        cell.subtitleThreeLabel.text = invoice.uniqueInvoiceNo;
        
        NSLog(@"invoice paid = %@", invoice.paid);
        
    }
    
    return cell;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"AddInvoiceDetailSegue"]) {
        
        // perform your computation to determine whether segue should occur
        BOOL segueShouldOccur = NO; // you determine this
        
        if (invoices.count < 3 || [LACHelperMethods fullUser]) {
            
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
                                         message:@"To add more invoices you need to upgrade to the pro account."
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

    if ([segue.identifier isEqualToString:@"InvoiceDetailSegue"]) {
        InvoiceDetailTVC *invoiceDetailTVC = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        Invoice *invoice = [self.invoices objectAtIndex:indexPath.row];
        invoiceDetailTVC.managedObjectId = invoice.objectID;
        
        [invoiceDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
        }];
        
    }
    else if ([segue.identifier isEqualToString:@"AddInvoiceDetailSegue"]) {
        InvoiceDetailTVC *invoiceDetailTVC = segue.destinationViewController;
        
        [invoiceDetailTVC setUpdateCompletionBlock:^{
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
