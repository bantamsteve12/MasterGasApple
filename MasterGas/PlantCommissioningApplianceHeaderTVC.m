//
//  PlantCommissioningApplianceHeaderTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 20/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import "PlantCommissioningApplianceHeaderTVC.h"
#import "AppointmentTVC.h"
#import "SDCoreDataController.h"

#import "PlantCommissioningService.h"
#import "PlantComServiceApplianceInspection.h"
#import "PlantCommissioningServiceApplianceInspectionTVC.h"

//#import "CertificateHeaderTVC.h"


@interface PlantCommissioningApplianceHeaderTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation PlantCommissioningApplianceHeaderTVC

@synthesize dateFormatter;

@synthesize entityName;
@synthesize refreshButton;
@synthesize maxAppliances;
@synthesize applianceInspections;
@synthesize selectedApplianceInspection;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;
@synthesize certificateNumber;

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
                                     [NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"certificateReference == %@", self.certificateNumber]];
        
        self.applianceInspections = [self.managedObjectContext executeFetchRequest:request error:&error];
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
    //  [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self loadRecordsFromCoreData];
    
}


- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.applianceInspections.count < 1) {
        return @"Press the + button to add your first appliance";
    }
    else
    {
        return @"Press the + button to add more appliances";
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
    return [self.applianceInspections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSLog(@"entity name = %@", self.entityName);
    
    if ([self.entityName isEqualToString:@"PlantComServiceApplianceInspection"]) {
        static NSString *CellIdentifier = @"ApplianceInspectionCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        PlantComServiceApplianceInspection *applianceInspection = [self.applianceInspections objectAtIndex:indexPath.row];
        cell.textLabel.text = applianceInspection.location;
        NSString *detailString = [NSString stringWithFormat:@"%@ / %@", applianceInspection.manufacturer, applianceInspection.model];
        cell.detailTextLabel.text = detailString;
    }
    
    return cell;
}

NSIndexPath *_tmpIndexPath;

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        _tmpIndexPath = indexPath;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this appliance inspection?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
        
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [self deleteApplianceInspection];
    }
}

-(void)deleteApplianceInspection
{
    NSManagedObject *date = [self.applianceInspections objectAtIndex:_tmpIndexPath.row];
    [self.managedObjectContext performBlockAndWait:^{
      
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
  

    if ([segue.identifier isEqualToString:@"ApplianceInspectionDetailSegue"]) {
        PlantCommissioningServiceApplianceInspectionTVC *applianceInspectionDetailTVC = segue.destinationViewController;
        
        // Store selected Person in selectedPerson property
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.selectedApplianceInspection = [self.applianceInspections objectAtIndex:indexPath.row];
      
        NSLog(@"selected Appliance Inspection %@",  self.selectedApplianceInspection.certificateReference);
        
        applianceInspectionDetailTVC.selectedApplianceInspection = self.selectedApplianceInspection;
        applianceInspectionDetailTVC.managedObjectContext = self.managedObjectContext;
        applianceInspectionDetailTVC.certificateNumber = self.certificateNumber;
        
        [applianceInspectionDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            //  [[SDSyncEngine sharedEngine] startSync];
        }];
    }
    else if ([segue.identifier isEqualToString:@"AddApplianceInspectionDetailSegue"]) {
        
        PlantCommissioningServiceApplianceInspectionTVC *applianceInspectionDetailTVC = segue.destinationViewController;
        applianceInspectionDetailTVC.managedObjectContext = managedObjectContext;
        applianceInspectionDetailTVC.certificateNumber = self.certificateNumber;
        
        [applianceInspectionDetailTVC setUpdateCompletionBlock:^{
            [self loadRecordsFromCoreData];
            [self.tableView reloadData];
            // [[SDSyncEngine sharedEngine] startSync];
        }];
        
    }
}



- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"AddApplianceInspectionDetailSegue"]) {
        // perform your computation to determine whether segue should occur
        
        BOOL segueShouldOccur = NO; // you determine this
        
        int max = [self.maxAppliances intValue];
        
        if (applianceInspections.count < max) {
            segueShouldOccur = YES;
        }
        
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:[NSString stringWithFormat:@"%i Max Appliances Reached", max]
                                         message:[NSString stringWithFormat:@"A maximum of %i appliance inspections can be entered.", max]
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

- (IBAction)refreshButtonTouched:(id)sender {
    //[[SDSyncEngine sharedEngine] startSync];
}


@end