//
//  GasMaintenanceSafetyChecksTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 26/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "GasMaintenanceSafetyChecksTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "LACHelperMethods.h"

@interface GasMaintenanceSafetyChecksTVC ()
@property CGPoint originalCenter;
@end

@implementation GasMaintenanceSafetyChecksTVC

@synthesize entityName;
@synthesize safteyVentilationSegmentControl;
@synthesize safetyVentilationTextField;
@synthesize safetyFlueTerminationSegmentControl;
@synthesize safetyFlueTerminationTextField;
@synthesize safetyFlueflowTestSegmentControl;
@synthesize safetyFlueflowTestTextField;
@synthesize safetySpilageTestSegmentControl;
@synthesize safetySpilageTestTextField;
@synthesize safetyOperatingPressureHeatInputSegmentControl;
@synthesize safetyOperatingPressureHeatInputTextField;
@synthesize safetyDevicesSegmentControl;
@synthesize safetyDevicesTextField;
@synthesize safetyOtherSegmentControl;
@synthesize safetyOtherTextField;

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
    self.safetyDevicesTextField.text = [self.managedObject valueForKey:@"safetyDeviceNotes"];
    self.safetyFlueflowTestTextField.text = [self.managedObject valueForKey:@"safetyFlueFlowTestNotes"];
    self.safetyFlueTerminationTextField.text = [self.managedObject valueForKey:@"safetyFlueTerminationNotes"];
    self.safetyOperatingPressureHeatInputTextField.text = [self.managedObject valueForKey:@"safetyOperatingPressureHeatInputNotes"];
    self.safetyOtherTextField.text = [self.managedObject valueForKey:@"safetyOtherNotes"];
    self.safetySpilageTestTextField.text = [self.managedObject valueForKey:@"safetySpilageTestNotes"];
    self.safetyVentilationTextField.text = [self.managedObject valueForKey:@"safetyVentilationNotes"];
   
     
    self.safetyDevicesSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"safetyDevice"]];
    
    self.safetyFlueflowTestSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"safetyFlueFlowTest"]];
    
    self.safetyFlueTerminationSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"safetyFlueTermination"]];
    
    self.safetyOperatingPressureHeatInputSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"safetyOperatingPressureHeatInput"]];
    
    self.safetyOtherSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"safetyOther"]];
    
    self.safetySpilageTestSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"safetySpilageTest"]];
    
    self.safteyVentilationSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"safetyVentilation"]];
    
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
    
    [self.managedObject setValue:[NSString checkForNilString:self.safetyDevicesTextField.text] forKey:@"safetyDeviceNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.safetyFlueflowTestTextField.text] forKey:@"safetyFlueFlowTestNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.safetyFlueTerminationTextField.text] forKey:@"safetyFlueTerminationNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.safetyOperatingPressureHeatInputTextField.text] forKey:@"safetyOperatingPressureHeatInputNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.safetyOtherTextField.text] forKey:@"safetyOtherNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.safetySpilageTestTextField.text] forKey:@"safetySpilageTestNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.safetyVentilationTextField.text] forKey:@"safetyVentilationNotes"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.safetyDevicesSegmentControl.selectedSegmentIndex] forKey:@"safetyDevice"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.safetyFlueflowTestSegmentControl.selectedSegmentIndex] forKey:@"safetyFlueFlowTest"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.safetyFlueTerminationSegmentControl.selectedSegmentIndex] forKey:@"safetyFlueTermination"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.safetyOperatingPressureHeatInputSegmentControl.selectedSegmentIndex] forKey:@"safetyOperatingPressureHeatInput"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.safetyOtherSegmentControl.selectedSegmentIndex] forKey:@"safetyOther"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.safetySpilageTestSegmentControl.selectedSegmentIndex] forKey:@"safetySpilageTest"];
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.safteyVentilationSegmentControl.selectedSegmentIndex] forKey:@"safetyVentilation"];
    
    
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
