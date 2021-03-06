//
//  OnMYWayLookupTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 29/01/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import "OnMYWayLookupTVC.h"
#import "SDCoreDataController.h"

@interface OnMYWayLookupTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation OnMYWayLookupTVC


@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize onMyWayItems;
@synthesize selectedOnMyWayItem;
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
        self.onMyWayItems = [self.managedObjectContext executeFetchRequest:request error:&error];
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
    
    if (self.onMyWayItems.count < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"On My Way"
                                                        message: @"You need to setup your on my way presets. Go to settings -> on my way and add them there."
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.onMyWayItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    cell.textLabel.numberOfLines = 4;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"OnMyWay"]) {
        static NSString *CellIdentifier = @"OnMyWayCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        OnMyWay *onMyWayItem = [self.onMyWayItems objectAtIndex:indexPath.row];
        cell.textLabel.text = onMyWayItem.name;
        
    }
    
    return cell;
}


- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    OnMyWay *onMyWayItem = [self.onMyWayItems objectAtIndex:indexPath.row];
    selectedOnMyWayItem = onMyWayItem;
    [self.delegate theOnMyWayLookupWasSelectedFromTheList:self];
}


- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
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


@end

