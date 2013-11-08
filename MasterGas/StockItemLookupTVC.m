//
//  StockItemLookupTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 08/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "StockItemLookupTVC.h"
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"
#import "LACHelperMethods.h"

@interface StockItemLookupTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation StockItemLookupTVC

@synthesize managedObjectContext;
@synthesize entityName;
@synthesize refreshButton;
@synthesize stockItems;
@synthesize selectedStockItem;
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
        
    /*    [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"stockCategory" ascending:YES],
                                     [NSSortDescriptor sortDescriptorWithKey:@"itemDescription" ascending:YES] Nil]; */
       
         
         request.sortDescriptors =  [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"stockCategory" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
                                     [NSSortDescriptor sortDescriptorWithKey:@"itemDescription" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]
                                    
                                     ,nil];

         
         
       //  [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        
        self.stockItems = [self.managedObjectContext executeFetchRequest:request error:&error];
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"AddInvoiceStockItemsSegue"]) {
        
        InvoiceStockItemDetailTVC *invoiceStockItemDetailTVC = segue.destinationViewController;
        invoiceStockItemDetailTVC.managedObjectContext = managedObjectContext;
        
    }
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadRecordsFromCoreData];
    [self setupTable];
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

-(void)viewWillAppear:(BOOL)animated
{
    [self setupTable];
}

-(void)setupTable
{
    self.sections = [[NSMutableDictionary alloc] init];
    
    BOOL found;
    
    // Loop through and create our keys
    for (StockItem *stockItem in self.stockItems)
    {
        NSString *category = stockItem.stockCategory;
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:category])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:category];
        }
    }
    
    for (StockItem *stockItem in self.stockItems)
    {
        NSString *category = stockItem.stockCategory;
        [[self.sections objectForKey:category] addObject:stockItem];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys])
    {
        [[self.sections objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"itemDescription" ascending:YES]]];
    }
    
    [self.tableView reloadData];
    
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
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"StockItem"]) {
        static NSString *CellIdentifier = @"StockItemCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
             
        StockItem *stockItem = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = stockItem.itemDescription;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Unit Price: %@%@",[LACHelperMethods getDefaultCurrency], stockItem.unitPrice];
    }
    return cell;
}


- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    StockItem *stockItem = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    selectedStockItem = stockItem;
    [self.delegate theStockItemWasSelectedFromTheList:self];
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
} */

@end
