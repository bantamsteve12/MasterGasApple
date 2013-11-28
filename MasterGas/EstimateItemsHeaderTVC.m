//
//  EstimateItemsHeaderTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 20/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "EstimateItemsHeaderTVC.h"
#import "SDCoreDataController.h"
#import "LACHelperMethods.h"


@interface EstimateItemsHeaderTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation EstimateItemsHeaderTVC


@synthesize dateFormatter;

@synthesize entityName;
@synthesize refreshButton;
@synthesize estimateItems;
@synthesize selectedEstimateItem;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;
@synthesize estimateUniqueNo;

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
                                     [NSSortDescriptor sortDescriptorWithKey:@"itemDescription" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"(estimateNo == %@)", self.estimateUniqueNo]];
        self.estimateItems = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
    
    [self loadRecordsFromCoreData];
}


- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.estimateItems.count < 1) {
        return @"Press the + button to add your first item";
    }
    else
    {
        return @"Press the + button to add more items";
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
    return [self.estimateItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainWithTwoSubtitlesCell *cell = nil;
    
    if ([self.entityName isEqualToString:@"EstimateItem"]) {
        static NSString *CellIdentifier = @"EstimateItemCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        EstimateItem *estimateItem = [self.estimateItems objectAtIndex:indexPath.row];
        cell.textLabel.text = estimateItem.itemDescription;
        cell.subtitleOneLabel.text = [NSString stringWithFormat:@"Quantity: %@", estimateItem.quantity];
        cell.subtitleTwoLabel.text = [NSString stringWithFormat:@"Total: %@%@",[LACHelperMethods getDefaultCurrency], estimateItem.total];
    }
    
    return cell;
}

NSIndexPath *_tmpIndexPath;

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _tmpIndexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self deleteItem];
    }
}

-(void)deleteItem
{
    NSManagedObject *date = [self.estimateItems objectAtIndex:_tmpIndexPath.row];
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
    if ([segue.identifier isEqualToString:@"EstimateItemDetailSegue"]) {
        
        EstimateItemDetailTVC *estimateItemDetailTVC = segue.destinationViewController;
        
        // Store selected Person in selectedPerson property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedEstimateItem = [self.estimateItems objectAtIndex:indexPath.row];
        
        estimateItemDetailTVC.selectedEstimateItem = self.selectedEstimateItem;
        estimateItemDetailTVC.managedObjectContext = self.managedObjectContext;
        estimateItemDetailTVC.estimateUniqueNo = self.estimateUniqueNo;
        
        [estimateItemDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            //     [[SDSyncEngine sharedEngine] startSync];
        }];
    }
    else if ([segue.identifier isEqualToString:@"AddEstimateItemDetailSegue"]) {
        
        EstimateItemDetailTVC *estimateItemDetailTVC = segue.destinationViewController;
        estimateItemDetailTVC.managedObjectContext = managedObjectContext;
        estimateItemDetailTVC.estimateUniqueNo = self.estimateUniqueNo;
        
        [estimateItemDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            //  [[SDSyncEngine sharedEngine] startSync];
        }];
    }
}


- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

@end
