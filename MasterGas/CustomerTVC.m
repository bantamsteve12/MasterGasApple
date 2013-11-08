//
//  CustomerTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 02/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//


#import "CustomerTVC.h"

#import <Parse/Parse.h>
#import "AppointmentTVC.h"
#import "SDCoreDataController.h"
#import "SDTableViewCell.h"
#import "SDAddDateViewController.h"
#import "SDDateDetailViewController.h"
#import "Customer.h"
//#import "SDSyncEngine.h"

#import "AddAppointmentTVC.h"

#import "AddCustomerTVC.h"
#import "CustomerDetailTVC.h"


@interface CustomerTVC ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation CustomerTVC

@synthesize dateFormatter;
@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize customers;

@synthesize sections;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
       
    }
    return self;
}

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]]; 
       // [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        self.customers = [self.managedObjectContext executeFetchRequest:request error:&error];
        [self setupTable];
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


-(void)viewWillAppear:(BOOL)animated
{
    [self loadRecordsFromCoreData];
}

-(void)setupTable
{
    self.sections = [[NSMutableDictionary alloc] init];
    
    BOOL found;
    
    NSLog(@"customer count = %i", [self.customers count]);
    
    // Loop through and create our keys
    for (Customer *test in self.customers)
    {
        NSString *c =  [test.name substringToIndex:1];
        [c uppercaseString];
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            
            if ([[str uppercaseString] isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:[c uppercaseString]];
        }
    }
    
    
    for (Customer *cust in self.customers)
    {
        NSString *c = [[cust.name substringToIndex:1] uppercaseString];
        
        [[self.sections objectForKey:c] addObject:cust];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    }
    
    [self.tableView reloadData];
    
}




- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
  // [self checkSyncStatus];
   /*
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self loadRecordsFromCoreData];
        [self.tableView reloadData];
    }];
    [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil]; */
    
    }



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
  
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
    //[[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
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
   
        //NSManagedObject *obj = [self.customers objectAtIndex:indexPath.row];
   
        
        Customer *cust = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        
    [self.managedObjectContext performBlockAndWait:^{
     if ([[cust valueForKey:@"objectId"] isEqualToString:@""] || [cust valueForKey:@"objectId"] == nil) {
     [self.managedObjectContext deleteObject:cust];
     } else {
  //   [cust setValue:[NSNumber numberWithInt:SDObjectDeleted] forKey:@"syncStatus"];
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
    return [[self.sections allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"Customer"]) {
        static NSString *CellIdentifier = @"CustomerCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       
        NSLog(@"self.sections count = %i", [self.sections count]);
        
        
       Customer *cust = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
       
        cell.textLabel.text = cust.name;
        NSString *addressLine = [NSString stringWithFormat:@"%1$@, %2$@", cust.addressLine1, cust.postcode];
        cell.detailTextLabel.text =  addressLine;
        
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowCustomerDetailSegue"]) {
        
        CustomerDetailTVC *customerDetailTVC = segue.destinationViewController;
         UITableViewCell *cell = (UITableViewCell *)sender;
         NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
       
        
        Customer *customer = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        
        customerDetailTVC.managedObjectId = customer.objectID;
      
        [customerDetailTVC setUpdateCustomerCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
         //   [[SDSyncEngine sharedEngine] startSync];
        }];

        
        
    } else if ([segue.identifier isEqualToString:@"ShowAddCustomer"]) {
        AddCustomerTVC *addCustomerTVC = segue.destinationViewController;
        [addCustomerTVC setAddDateCompletionBlock:^{
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
}
 */

@end
