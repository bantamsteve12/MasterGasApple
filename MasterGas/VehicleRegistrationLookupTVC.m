//
//  VehicleRegistrationLookupTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 05/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "VehicleRegistrationLookupTVC.h"
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"

@interface VehicleRegistrationLookupTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation VehicleRegistrationLookupTVC

@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize vehicleRegistrations;
@synthesize selectedVehicleRegistration;
@synthesize delegate;

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
        [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        self.vehicleRegistrations = [self.managedObjectContext executeFetchRequest:request error:&error];
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
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
  //  [self checkSyncStatus];
    
  //  [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
    
        [self loadRecordsFromCoreData];
        [self.tableView reloadData];
    //}];
    //[[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
   // [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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
    return [self.vehicleRegistrations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"VehicleRegistration"]) {
        static NSString *CellIdentifier = @"VehicleRegistrationCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        VehicleRegistration *vehicleRegistration = [self.vehicleRegistrations objectAtIndex:indexPath.row];
        cell.textLabel.text = vehicleRegistration.name;
        
    }
    
    return cell;
}


- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    VehicleRegistration *vehicleRegistration = [self.vehicleRegistrations objectAtIndex:indexPath.row];
    selectedVehicleRegistration = vehicleRegistration;
    [self.delegate theVehicleRegistrationWasSelectedFromTheList:self];
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
