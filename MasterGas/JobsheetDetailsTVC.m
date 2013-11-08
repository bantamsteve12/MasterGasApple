//
//  JobsheetDetailsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 05/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "JobsheetDetailsTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"


@interface JobsheetDetailsTVC ()
@property CGPoint originalCenter;
@end

@implementation JobsheetDetailsTVC


@synthesize entityName;

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
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
