//
//  ReminderSelectionTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 17/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "ReminderSelectionTVC.h"


@interface ReminderSelectionTVC ()

@end


@implementation ReminderSelectionTVC

@synthesize monthLabel;
@synthesize yearLabel;
@synthesize typeLabel;
@synthesize updateCompletionBlock;


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
}


- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"YearsLookupSegue"]) {
        ReminderCritieriaLookupTVC *reminderCritieraTVC = segue.destinationViewController;
        reminderCritieraTVC.selectedEntity = @"Years";
        reminderCritieraTVC.delegate = self;
        
    }
    else if ([segue.identifier isEqualToString:@"MonthsLookupSegue"]) {
        ReminderCritieriaLookupTVC *reminderCritieraTVC = segue.destinationViewController;
        reminderCritieraTVC.selectedEntity = @"Months";
        reminderCritieraTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"TypesLookupSegue"]) {
        ReminderCritieriaLookupTVC *reminderCritieraTVC = segue.destinationViewController;
        reminderCritieraTVC.selectedEntity = @"Types";
        reminderCritieraTVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"ShowResultsSegue"]) {
        ReminderResultsTVC *reminderResultsTVC = segue.destinationViewController;
     
        reminderResultsTVC.month = self.monthLabel.text;
        reminderResultsTVC.year = self.yearLabel.text;
        
        if ([typeLabel.text isEqualToString:@"Landlord Gas Safety Record"]) {
             reminderResultsTVC.entityName = @"Certificate";
        }
        else if ([typeLabel.text isEqualToString:@"Gas Breakdown Servicing"]) {
             reminderResultsTVC.entityName = @"MaintenanceServiceRecord";
        }
        else if ([typeLabel.text isEqualToString:@"Gas Service Maintenance"]) {
             reminderResultsTVC.entityName = @"MaintenanceServiceCheck";
        }
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ShowResultsSegue"]) {
        // perform your computation to determine whether segue should occur
        
        BOOL segueShouldOccur = NO; // you determine this
        
        NSLog(@"yearLabel = %@", self.yearLabel.text);
        
        if ((![self.yearLabel.text isEqualToString:@"..."]) &&
            (![self.monthLabel.text isEqualToString:@"..."]) &&
            (![self.typeLabel.text isEqualToString:@"..."]))
        {
            segueShouldOccur = YES;
        }
        
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"All Section criteria required"
                                         message:@"A Month, Year and Type are required"
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


-(void)theOptionWasSelectedFromTheList:(ReminderCritieriaLookupTVC *)controller
{
    if ([controller.selectedEntity isEqualToString:@"Months"]) {
        self.monthLabel.text = controller.selectedOption;
    }
    else if([controller.selectedEntity isEqualToString:@"Years"]) {
        self.yearLabel.text = controller.selectedOption;
    }
    else if([controller.selectedEntity isEqualToString:@"Types"]) {
        self.typeLabel.text = controller.selectedOption;
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
