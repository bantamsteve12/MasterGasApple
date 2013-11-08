//
//  ReminderCritieriaLookupTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 17/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "ReminderCritieriaLookupTVC.h"
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"

@interface ReminderCritieriaLookupTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation ReminderCritieriaLookupTVC


@synthesize managedObjectContext;
@synthesize arrayItems;
@synthesize selectedEntity;
@synthesize selectedOption;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadArray {
   
    if ([self.selectedEntity isEqualToString:@"Years"]) {
      self.arrayItems  = [NSArray arrayWithObjects:@"2013",@"2014",@"2015",nil];
    }
    else if ([self.selectedEntity isEqualToString:@"Months"]) {
        self.arrayItems  = [NSArray arrayWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
    }
    else if ([self.selectedEntity isEqualToString:@"Types"]) {
        self.arrayItems  = [NSArray arrayWithObjects:@"Landlord Gas Safety Record",@"Gas Breakdown Servicing",@"Gas Service Maintenance",nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadArray];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    return [self.arrayItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    static NSString *CellIdentifier = @"itemCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        NSString *item = [self.arrayItems objectAtIndex:indexPath.row];
        cell.textLabel.text = item;
    
    return cell;
}


- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    NSString *selectedItem = [self.arrayItems objectAtIndex:indexPath.row];
    self.selectedOption = selectedItem;
    [self.delegate theOptionWasSelectedFromTheList:self];
    
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
