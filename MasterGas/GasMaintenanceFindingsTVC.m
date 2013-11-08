//
//  GasMaintenanceFindingsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 24/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "GasMaintenanceFindingsTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "LACHelperMethods.h"


@interface GasMaintenanceFindingsTVC ()
@property CGPoint originalCenter;

@end

@implementation GasMaintenanceFindingsTVC


@synthesize entityName;


@synthesize applianceInstallationSafeToUseSegmentControl;
@synthesize warningLabelAttachedSegmentControl;
@synthesize installationConformToMIandISSegementControl;
@synthesize remedialWorkRequiredTextView;

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
    self.remedialWorkRequiredTextView.text = [self.managedObject valueForKey:@"findingsRemedialWorkRequired"];    
    self.applianceInstallationSafeToUseSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"findingsApplianceSafeToUse"]];
    
    self.warningLabelAttachedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"findingsApplianceSafeWarningNoticeAttached"]];
    
    self.installationConformToMIandISSegementControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"findingsConformToMIandIS"]];
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
    
    [self.managedObject setValue:[NSString checkForNilString:self.remedialWorkRequiredTextView.text] forKey:@"findingsRemedialWorkRequired"];
      
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.applianceInstallationSafeToUseSegmentControl.selectedSegmentIndex] forKey:@"findingsApplianceSafeToUse"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.warningLabelAttachedSegmentControl.selectedSegmentIndex] forKey:@"findingsApplianceSafeWarningNoticeAttached"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.installationConformToMIandISSegementControl.selectedSegmentIndex] forKey:@"findingsConformToMIandIS"];
    
    
   
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        BOOL saved = [self.managedObjectContext save:&error];
        if (!saved) {
            // do some real error handling
            NSLog(@"Could not save Date due to %@", error);
        }
        [[SDCoreDataController sharedInstance] saveMasterContext];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    //  addDateCompletionBlock();
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
