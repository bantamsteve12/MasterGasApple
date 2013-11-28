//
//  SitesTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 30/10/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "SitesTVC.h"
#import "Sites.h"
#import "SDCoreDataController.h"
#import "AddAppointmentTVC.h"
#import "CustomerDetailTVC.h"
#import "SiteDetailTVC.h"


@interface SitesTVC ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation SitesTVC

@synthesize dateFormatter;
@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize sites;

@synthesize sections;

@synthesize customerNo;


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
        [request setPredicate:[NSPredicate predicateWithFormat:@"customerNo == %@", self.customerNo]];
        self.sites = [self.managedObjectContext executeFetchRequest:request error:&error];
        [self setupTable];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"customerNo: %@", self.customerNo);
    
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
    
    
    // Loop through and create our keys
    for (Sites *site in self.sites)
    {
        NSString *c =  [site.name substringToIndex:1];
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
    
    
    for (Sites *site in self.sites)
    {
        NSString *c = [[site.name substringToIndex:1] uppercaseString];
        
        [[self.sections objectForKey:c] addObject:site];
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
        
        
        Sites *site = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        
        [self.managedObjectContext performBlockAndWait:^{
           
                [self.managedObjectContext deleteObject:site];
           
            
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
    
    if ([self.entityName isEqualToString:@"Sites"]) {
        static NSString *CellIdentifier = @"SiteCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        NSLog(@"self.sections count = %i", [self.sections count]);
        
        
        Sites *site = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = site.name;
        NSString *addressLine = [NSString stringWithFormat:@"%1$@, %2$@", site.addressLine1, site.postcode];
        cell.detailTextLabel.text =  addressLine;
        
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowSiteDetailSegue"]) {
        
        SiteDetailTVC *siteDetailTVC = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        Sites *site = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        siteDetailTVC.customerNo = self.customerNo;
        siteDetailTVC.currentSite = site;
        
    
        siteDetailTVC.managedObjectId = site.objectID;
        
        
        
        [siteDetailTVC setAddDateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
        }];
        
   
        
        
    } else if ([segue.identifier isEqualToString:@"AddSiteSegue"]) {
        SiteDetailTVC *addSiteTVC = segue.destinationViewController;
        addSiteTVC.customerNo = self.customerNo;
        [addSiteTVC setAddDateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
        }];
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"AddSiteSegue"]) {
        // perform your computation to determine whether segue should occur
        
        BOOL segueShouldOccur = NO;         
        if (self.customerNo.length > 0) {
            segueShouldOccur = YES;
        }
        
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"No customer selected"
                                         message:@"Please select a customer on the previous screen first before adding a new site."
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


@end
