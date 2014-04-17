//
//  JobsheetDetailsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 05/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "JobsheetDetailsTVC.h"
#import "SDCoreDataController.h"

@interface JobsheetDetailsTVC ()
@property CGPoint originalCenter;
@end

@implementation JobsheetDetailsTVC


@synthesize entityName;

@synthesize applianceType;
@synthesize applianceMake;
@synthesize applianceModel;
@synthesize applianceSerial;
@synthesize applianceLocation;
@synthesize jobNotesTextView;
@synthesize sparesRequiredTextView;
@synthesize sparesUsedTextView;
@synthesize materialsPurcasedTextView;

@synthesize managedObjectContext;
@synthesize managedObject;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
    // load values if present
    
    self.applianceLocation.text = [self.managedObject valueForKey:@"applianceLocation"];
    self.applianceMake.text = [self.managedObject valueForKey:@"applianceMake"];
    self.applianceModel.text = [self.managedObject valueForKey:@"applianceModel"];
    self.applianceSerial.text = [self.managedObject valueForKey:@"applianceSerial"];
    self.applianceType.text = [self.managedObject valueForKey:@"applianceType"];
    
    self.jobNotesTextView.text = [self.managedObject valueForKey:@"notes"];
    self.sparesRequiredTextView.text = [self.managedObject valueForKey:@"sparesRequired"];
    self.sparesUsedTextView.text = [self.managedObject valueForKey:@"sparesUsed"];
    self.materialsPurcasedTextView.text = [self.managedObject valueForKey:@"materialsPurchased"];
       
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}


- (IBAction)cancelButtonPressed:(id)sender {
    NSLog(@"Cancel button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveButtonTouched:(id)sender {
       
    [self SaveAll];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SaveAll
{
    
    [self.managedObject setValue:[NSString checkForNilString:self.applianceLocation.text] forKey:@"applianceLocation"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceMake.text] forKey:@"applianceMake"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceModel.text] forKey:@"applianceModel"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceType.text] forKey:@"applianceType"];
    [self.managedObject setValue:[NSString checkForNilString:self.applianceSerial.text] forKey:@"applianceSerial"];
    [self.managedObject setValue:[NSString checkForNilString:self.jobNotesTextView.text] forKey:@"notes"];
    [self.managedObject setValue:[NSString checkForNilString:self.sparesRequiredTextView.text] forKey:@"sparesRequired"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.sparesUsedTextView.text] forKey:@"sparesUsed"];
    [self.managedObject setValue:[NSString checkForNilString:self.self.materialsPurcasedTextView.text] forKey:@"materialsPurchased"];
    
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save Date due to %@", error);
        }
        [[SDCoreDataController sharedInstance] saveMasterContext];
    }];

}

#pragma Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SelectLocationLookupSegue"]) {
        LocationLookupTVC *locationLookupTVC = segue.destinationViewController;
        locationLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"SelectApplianceTypeLookupSegue"]) {
        ApplianceTypeLookupTVC *applianceTypeLookupTVC = segue.destinationViewController;
        applianceTypeLookupTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"SelectApplianceMakeLookupSegue"]) {
        ApplianceMakeLookupTVC *applianceMakeLookupTVC = segue.destinationViewController;
        applianceMakeLookupTVC.delegate = self;
    }
   
}


#pragma Delegate methods

-(void)theLocationWasSelectedFromTheList:(LocationLookupTVC *)controller
{
    self.applianceLocation.text = controller.selectedLocation.name;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)theApplianceTypeWasSelectedFromTheList:(ApplianceTypeLookupTVC *)controller
{
    self.applianceType.text = controller.selectedApplianceType.name;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)theApplianceMakeWasSelectedFromTheList:(ApplianceMakeLookupTVC *)controller
{
    self.applianceMake.text = controller.selectedApplianceMake.name;
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self SaveAll];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
