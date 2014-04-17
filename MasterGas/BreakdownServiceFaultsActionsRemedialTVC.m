//
//  BreakdownServiceFaultsActionsRemedialTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 16/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "BreakdownServiceFaultsActionsRemedialTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "LACHelperMethods.h"


@interface BreakdownServiceFaultsActionsRemedialTVC ()
@property CGPoint originalCenter;
@end

@implementation BreakdownServiceFaultsActionsRemedialTVC


@synthesize entityName;

@synthesize detailsOfFaultsTextView;
@synthesize remedialWorkTakenTextView;
@synthesize warningNoticeIssuedSegmentControl;
@synthesize warningNoticeNumberTextField;


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
    self.detailsOfFaultsTextView.text = [self.managedObject valueForKey:@"faults"];
    self.remedialWorkTakenTextView.text = [self.managedObject valueForKey:@"actionRemedialWork"];
    
    self.warningNoticeNumberTextField.text = [self.managedObject valueForKey:@"warningAdviceNumber"];
    
    self.warningNoticeIssuedSegmentControl.selectedSegmentIndex = [LACHelperMethods YesNoNASegementControlSelectedIndexForValue:[self.managedObject valueForKey:@"warningLabelIssued"]];
    
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
    
    // TODO: Add in name values
    [self.managedObject setValue:[NSString checkForNilString:self.detailsOfFaultsTextView.text] forKey:@"faults"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.remedialWorkTakenTextView.text] forKey:@"actionRemedialWork"];
    
    [self.managedObject setValue:[NSString checkForNilString:self.warningNoticeNumberTextField.text] forKey:@"warningAdviceNumber"];
    
    
    [self.managedObject setValue:[LACHelperMethods YesNoNASegementControlValue:self.warningNoticeIssuedSegmentControl.selectedSegmentIndex] forKey:@"warningLabelIssued"];
    
    
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
