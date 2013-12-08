//
//  SelectEstimateTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 06/12/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "SelectEstimateTVC.h"
#import "SDCoreDataController.h"
#import "Estimate.h"
#import "EstimateDetailTVC.h"
#import "NSString+Additions.h"
#import "LACHelperMethods.h"

@interface SelectEstimateTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation SelectEstimateTVC

@synthesize dateFormatter;
@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize estimates;
@synthesize customerId;
@synthesize selectedEstimate;
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
        
        NSString *amount = [NSString stringWithFormat:@"Total: %@%@ ", [LACHelperMethods getDefaultCurrency],[NSString checkForNilString:estimate.total]];
        
        cell.subtitleOneLabel.text = amount;
        cell.subtitleTwoLabel.text = [self.dateFormatter stringFromDate:estimate.date];
        cell.subtitleThreeLabel.text = estimate.uniqueEstimateNo;
        
    }
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    Estimate *estimate = [self.estimates objectAtIndex:indexPath.row];
    selectedEstimate = estimate;
    [self.delegate theEstimateWasSelectedFromTheList:self];
}


- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}


@end
