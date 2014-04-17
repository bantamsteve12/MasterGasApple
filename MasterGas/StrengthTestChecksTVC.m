//
//  StrengthTestChecksTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 15/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import "StrengthTestChecksTVC.h"
#import "SDCoreDataController.h"
#import "LACHelperMethods.h"

@interface StrengthTestChecksTVC ()
@property CGPoint originalCenter;
@end

@implementation StrengthTestChecksTVC

@synthesize entityName;
@synthesize stTestMethodSegmentControl;
@synthesize stInstallationTypeSegmentControl;
@synthesize stComponentsNotSuitableRemovedSegmentControl;
@synthesize stCalculatedStrengthTestPressureValueTextField;
@synthesize stCalculatedStrengthTestPressureUnitSegmentControl;
@synthesize stTestMediumTextField;
@synthesize stStabilisationPeriodTextField;
@synthesize stStrengthTestDurationTextField;
@synthesize stPermittedPressureDropValueTextField;
@synthesize stCalculatedPressureDropValueTextField;
@synthesize stCalculatedPressureDropUnitSegmentControl;
@synthesize stActualPressureDropValueTextField;
@synthesize stActualPressureDropUnitSegmentControl;
@synthesize stStrengthTestPassFailSegmentControl;

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



/*
 + (NSString *)PassFailNASegementControlValue:(int)selectedIndex;
 + (int)PassFailNASegementControlSelectedIndexForValue:(NSString *)value;
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    [self.tableView addGestureRecognizer:tgr];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    

  // load values if present
    self.stTestMethodSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"Pneumatic (p)", @"Hydrostatic (H)"] withValue:[self.managedObject valueForKey:@"stTestMethod"]];
    
    self.stInstallationTypeSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"New", @"New Extension", @"Existing"] withValue:[self.managedObject valueForKey:@"stInstallationType"]];
    
    self.stComponentsNotSuitableRemovedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"stComponentsIsolated"]];
    
    self.stCalculatedStrengthTestPressureValueTextField.text = [self.managedObject valueForKey:@"stStrengthTestPressure"];
    
    self.stCalculatedStrengthTestPressureUnitSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"mbar", @"bar"] withValue:[self.managedObject valueForKey:@"stStrengthTestPressureUnit"]];
    
    self.stTestMediumTextField.text = [self.managedObject valueForKey:@"stTestMedium"];
    self.stStabilisationPeriodTextField.text = [self.managedObject valueForKey:@"stStabilisationPeriod"];
    self.stStrengthTestDurationTextField.text = [self.managedObject valueForKey:@"stStrengthTestDuration"];
    self.stPermittedPressureDropValueTextField.text = [self.managedObject valueForKey:@"stPermittedPressureDrop"];
    self.stCalculatedPressureDropValueTextField.text = [self.managedObject valueForKey:@"stCalculatedPressureDrop"];
    
    self.stCalculatedPressureDropUnitSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"mbar", @"bar"] withValue:[self.managedObject valueForKey:@"stCalculatedPressureDropUnit"]];
    
    self.stActualPressureDropValueTextField.text = [self.managedObject valueForKey:@"stActualPressureDrop"];
    
    self.stActualPressureDropUnitSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"mbar", @"bar"] withValue:[self.managedObject valueForKey:@"stActualPressureDropUnit"]];
    
    self.stStrengthTestPassFailSegmentControl.selectedSegmentIndex = [LACHelperMethods SegementIndexValue:@[@"Pass", @"Fail"] withValue:[self.managedObject valueForKey:@"stStrengthTestPassFail"]];
 
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
    //  addDateCompletionBlock();
    
    
}


-(void)SaveAll
{
    // SAVE
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"Pneumatic (p)", @"Hydrostatic (H)"]withIndex:self.stTestMethodSegmentControl.selectedSegmentIndex] forKey:@"stTestMethod"];
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"New", @"New Extension", @"Existing"] withIndex:self.stInstallationTypeSegmentControl.selectedSegmentIndex] forKey:@"stInstallationType"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.stComponentsNotSuitableRemovedSegmentControl.selectedSegmentIndex] forKey:@"stComponentsIsolated"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.stCalculatedStrengthTestPressureValueTextField.text] forKey:@"stStrengthTestPressure"];
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"mbar", @"bar"]withIndex:self.stCalculatedStrengthTestPressureUnitSegmentControl.selectedSegmentIndex] forKey:@"stStrengthTestPressureUnit"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.stTestMediumTextField.text] forKey:@"stTestMedium"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.stStabilisationPeriodTextField.text] forKey:@"stStabilisationPeriod"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.stStrengthTestDurationTextField.text] forKey:@"stStrengthTestDuration"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.stPermittedPressureDropValueTextField.text] forKey:@"stPermittedPressureDrop"];
    
    
    [self.managedObject setValue:[NSString checkForNilString:self.stCalculatedPressureDropValueTextField.text] forKey:@"stCalculatedPressureDrop"];
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"mbar", @"bar"]withIndex:self.stCalculatedPressureDropUnitSegmentControl.selectedSegmentIndex] forKey:@"stCalculatedPressureDropUnit"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.stActualPressureDropValueTextField.text] forKey:@"stActualPressureDrop"];
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"mbar", @"bar"]withIndex:self.stActualPressureDropUnitSegmentControl.selectedSegmentIndex] forKey:@"stActualPressureDropUnit"];
    
    [self.managedObject setValue:[LACHelperMethods ValueForIndex:@[@"Pass", @"Fail"]withIndex:self.stStrengthTestPassFailSegmentControl.selectedSegmentIndex] forKey:@"stStrengthTestPassFail"];
    
    
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
