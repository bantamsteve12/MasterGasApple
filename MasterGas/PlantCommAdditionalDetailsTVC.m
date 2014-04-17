//
//  PlantCommAdditionalDetailsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 25/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import "PlantCommAdditionalDetailsTVC.h"
#import "SDCoreDataController.h"
#import "LACHelperMethods.h"


@interface PlantCommAdditionalDetailsTVC ()
@property CGPoint originalCenter;
@end

@implementation PlantCommAdditionalDetailsTVC

@synthesize entityName;
@synthesize ventilationNaturalLowLevelTextField;
@synthesize ventilationNaturalHighLevelTextField;
@synthesize ventilationNaturalClearSegmentControl;
@synthesize ventilationMechanicalInletTextField;
@synthesize ventilationMechanicalExtractTextField;
@synthesize ventilationMechanicalInterlockSegmentControl;
@synthesize ventilationMechanicalClearSegmentControl;
@synthesize workCarriedOutTextView;
@synthesize remedialWorkRequiredTextView;
@synthesize warningLabelNoticeIssuedSegmentControl;
@synthesize warningNoticeNumberTextField;
@synthesize responsiblePersonNotifiedWarningNoticeSegmentControl;
@synthesize responsiblePersonTextField;

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
    
    #pragma Load values
    
    self.ventilationNaturalLowLevelTextField.text = [self.managedObject valueForKey:@"ventilationNaturalLowLevel"];
    self.ventilationNaturalHighLevelTextField.text = [self.managedObject valueForKey:@"ventilationNaturalHighLevel"];
    self.ventilationNaturalClearSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ventilationNaturalGrillesClear"]];
    
    self.ventilationMechanicalInletTextField.text = [self.managedObject valueForKey:@"ventilationMechanicalInlet"];
    self.ventilationMechanicalExtractTextField.text = [self.managedObject valueForKey:@"ventilationMechanicalExtract"];
    
    self.ventilationMechanicalInterlockSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ventilationMechanicalInterlock"]];
   
    self.ventilationMechanicalClearSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"ventilationMechanicalClear"]];
   
    self.workCarriedOutTextView.text = [self.managedObject valueForKey:@"workCarriedOut"];
    self.remedialWorkRequiredTextView.text = [self.managedObject valueForKey:@"remedialWorkRequired"];
    
    self.warningLabelNoticeIssuedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"warningNoticeIssued"]];
    
    self.warningNoticeNumberTextField.text = [self.managedObject valueForKey:@"warningNoticeNumber"];
    
    self.responsiblePersonNotifiedWarningNoticeSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"responsiblePersonNotified"]];
    
     self.responsiblePersonTextField.text = [self.managedObject valueForKey:@"responsiblePersonName"];
    
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
#pragma Save Values
    
    [self.managedObject setValue:[NSString checkForNilString:self.ventilationNaturalLowLevelTextField.text] forKey:@"ventilationNaturalLowLevel"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.ventilationNaturalHighLevelTextField.text] forKey:@"ventilationNaturalHighLevel"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.ventilationNaturalClearSegmentControl.selectedSegmentIndex] forKey:@"ventilationNaturalGrillesClear"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.ventilationMechanicalInletTextField.text] forKey:@"ventilationMechanicalInlet"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.ventilationMechanicalExtractTextField.text] forKey:@"ventilationMechanicalExtract"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.ventilationMechanicalInterlockSegmentControl.selectedSegmentIndex] forKey:@"ventilationMechanicalInterlock"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.ventilationMechanicalClearSegmentControl.selectedSegmentIndex] forKey:@"ventilationMechanicalClear"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.workCarriedOutTextView.text] forKey:@"workCarriedOut"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.remedialWorkRequiredTextView.text] forKey:@"remedialWorkRequired"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.warningNoticeNumberTextField.text] forKey:@"warningNoticeNumber"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.warningLabelNoticeIssuedSegmentControl.selectedSegmentIndex] forKey:@"warningNoticeIssued"];
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.responsiblePersonNotifiedWarningNoticeSegmentControl.selectedSegmentIndex] forKey:@"responsiblePersonNotified"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.responsiblePersonTextField.text] forKey:@"responsiblePersonName"];
    
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

