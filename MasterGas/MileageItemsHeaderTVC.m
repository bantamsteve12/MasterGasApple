//
//  MileageItemsHeaderTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 05/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "MileageItemsHeaderTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "LACUsersHandler.h"

@interface MileageItemsHeaderTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MileageItemsHeaderTVC

@synthesize dateFormatter;
@synthesize entityName;
@synthesize refreshButton;
@synthesize mileageItems;
@synthesize selectedMileageItem;
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
     
    
        [request setPredicate:[NSPredicate predicateWithFormat:@"(mileageClaimUniqueNo == %@)", self.uniqueClaimNumber]];
        
        self.mileageItems = [self.managedObjectContext executeFetchRequest:request error:&error];
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
    if (self.mileageItems.count < 1) {
        return @"Press the + button to add your first journey";
    }
    else
    {
        return @"Press the + button to add more journeys";
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
    return [self.mileageItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainWithTwoSubtitlesCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"MileageItem"]) {
        static NSString *CellIdentifier = @"MileageItemCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        MileageItem *mileageItem = [self.mileageItems objectAtIndex:indexPath.row];
        cell.textLabel.text = mileageItem.journeyDescription;
        cell.subtitleOneLabel.text = [NSString stringWithFormat:@"Total Miles: %@", mileageItem.totalMileage];
        cell.subtitleTwoLabel.text = [self.dateFormatter stringFromDate:mileageItem.date];
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
    NSManagedObject *date = [self.mileageItems objectAtIndex:_tmpIndexPath.row];
    [self.managedObjectContext performBlockAndWait:^{
        if ([[date valueForKey:@"objectId"] isEqualToString:@""] || [date valueForKey:@"objectId"] == nil) {
            [self.managedObjectContext deleteObject:date];
        } else {
       //     [date setValue:[NSNumber numberWithInt:SDObjectDeleted] forKey:@"syncStatus"];
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
    
  
    
    if ([segue.identifier isEqualToString:@"MileageDetailSegue"]) {
        
        MileageItemDetailTVC *mileageItemDetailTVC = segue.destinationViewController;
        
        // Store selected Person in selectedPerson property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedMileageItem = [self.mileageItems objectAtIndex:indexPath.row];
        
        mileageItemDetailTVC.selectedMileageItem = self.selectedMileageItem;
        mileageItemDetailTVC.managedObjectContext = self.managedObjectContext;
        mileageItemDetailTVC.uniqueClaimNo = self.uniqueClaimNumber;
        
        NSLog(@"unique claim no: %@", self.uniqueClaimNumber);

        
        [mileageItemDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
      //      [[SDSyncEngine sharedEngine] startSync];
        }];
    }
    else if ([segue.identifier isEqualToString:@"AddMileageDetailSegue"]) {
        
        MileageItemDetailTVC *mileageItemDetailTVC = segue.destinationViewController;
        mileageItemDetailTVC.managedObjectContext = managedObjectContext;
        mileageItemDetailTVC.uniqueClaimNo = self.uniqueClaimNumber;
        
        NSLog(@"unique claim no: %@", self.uniqueClaimNumber);
        
        [mileageItemDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
       //    [[SDSyncEngine sharedEngine] startSync];
        }];
    } 
}


- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}


@end
