//
//  SiteLookupTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 31/10/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "SiteLookupTVC.h"
#import "SDCoreDataController.h"
#import "SiteDetailTVC.h"


@interface SiteLookupTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation SiteLookupTVC

@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize sites;
@synthesize selectedSite;
@synthesize delegate;

@synthesize sections;

@synthesize customerNo;

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


-(void)viewWillAppear:(BOOL)animated
{
    [self setupTable];
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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark Table view data source

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
    
    if ([self.entityName isEqualToString:@"Sites"]) {
        static NSString *CellIdentifier = @"SiteCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        Sites *site = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
        cell.textLabel.text = site.name;
        NSString *addressLine = [NSString stringWithFormat:@"%1$@, %2$@", site.addressLine1, site.postcode];
        cell.detailTextLabel.text =  addressLine;
        
    }
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    
    Sites *site = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    selectedSite = site;
    [self.delegate theSiteWasSelectedFromTheList:self];
}



-(void) perform:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)viewDidUnload {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        NSLog(@"Back button pressed");
    }
    
    
    [self setRefreshButton:nil];
    [super viewDidUnload];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"AddSiteAddressSegue"]) {
        SiteDetailTVC *addSiteTVC = segue.destinationViewController;
        addSiteTVC.customerNo = self.customerNo;
        [addSiteTVC setAddDateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
        }];
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"AddSiteAddressSegue"]) {
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


@end
