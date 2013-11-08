//
//  ExpenseItemsHeaderTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 01/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "ExpenseItemsHeaderTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "LACUsersHandler.h"

@interface ExpenseItemsHeaderTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation ExpenseItemsHeaderTVC

@synthesize dateFormatter;

@synthesize entityName;
@synthesize refreshButton;
@synthesize expenseItems;
@synthesize selectedExpenseItem;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;
@synthesize uniqueClaimNumber;

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
                                     [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"(expenseUniqueReference == %@) AND (engineerId == %@)", self.uniqueClaimNumber,[LACUsersHandler getCurrentEngineerId]]];
        
        self.expenseItems = [self.managedObjectContext executeFetchRequest:request error:&error];
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
    if (self.expenseItems.count < 1) {
        return @"Press the + button to add your first claim item";
    }
    else
    {
        return @"Press the + button to add more claim items";
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
   // [self checkSyncStatus];
    
   // [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self loadRecordsFromCoreData];
        [self.tableView reloadData];
   // }];
 //   [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
  //  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SDSyncEngineSyncCompleted" object:nil];
//    [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
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
    return [self.expenseItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainWithTwoSubtitlesCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"ExpenseItem"]) {
        static NSString *CellIdentifier = @"ExpenseItemCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        ExpenseItem *expenseItem = [self.expenseItems objectAtIndex:indexPath.row];
        cell.textLabel.text = expenseItem.itemDescription;
        cell.subtitleOneLabel.text = [NSString stringWithFormat:@"Total: £%@", expenseItem.totalAmount];
        cell.subtitleTwoLabel.text =  [self.dateFormatter stringFromDate:expenseItem.date];
        
        NSLog(@"expense supplier id: %@", expenseItem.supplierId);
        
    }
    
    return cell;
}

NSIndexPath *_tmpIndexPath;

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _tmpIndexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this expense item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self deleteExpenseItem];
    }
}

-(void)deleteExpenseItem
{
    NSManagedObject *date = [self.expenseItems objectAtIndex:_tmpIndexPath.row];
    [self.managedObjectContext performBlockAndWait:^{
        if ([[date valueForKey:@"objectId"] isEqualToString:@""] || [date valueForKey:@"objectId"] == nil) {
            [self.managedObjectContext deleteObject:date];
        } else {
        //    [date setValue:[NSNumber numberWithInt:SDObjectDeleted] forKey:@"syncStatus"];
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
    
    if ([segue.identifier isEqualToString:@"ExpenseDetailSegue"]) {
  
        
        ExpenseItemDetailTVC *expenseDetailTVC = segue.destinationViewController;
        
        // Store selected Person in selectedPerson property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedExpenseItem = [self.expenseItems objectAtIndex:indexPath.row];
     
        expenseDetailTVC.selectedExpenseItem = self.selectedExpenseItem;
        expenseDetailTVC.managedObjectContext = self.managedObjectContext;
        expenseDetailTVC.uniqueClaimNo = self.uniqueClaimNumber;
        
        [expenseDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
       //     [[SDSyncEngine sharedEngine] startSync];
        }];
    }
    else if ([segue.identifier isEqualToString:@"AddExpenseDetailSegue"]) {
        
        ExpenseItemDetailTVC *expenseDetailTVC = segue.destinationViewController;
        expenseDetailTVC.managedObjectContext = managedObjectContext;
        expenseDetailTVC.uniqueClaimNo = self.uniqueClaimNumber;

        [expenseDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
       //     [[SDSyncEngine sharedEngine] startSync];
        }];
    } 
}


- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

- (IBAction)refreshButtonTouched:(id)sender {
  //  [[SDSyncEngine sharedEngine] startSync];
}

/*
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
