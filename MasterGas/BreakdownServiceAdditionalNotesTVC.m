//
//  BreakdownServiceAdditionalNotesTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 14/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "BreakdownServiceAdditionalNotesTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"


@interface BreakdownServiceAdditionalNotesTVC ()
@property CGPoint originalCenter;
@end

@implementation BreakdownServiceAdditionalNotesTVC

@synthesize entityName;

@synthesize additionalNotesTextView;
@synthesize sparesRequiredTextView;


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
    self.additionalNotesTextView.text = [self.managedObject valueForKey:@"additionalNotes"];
    self.sparesRequiredTextView.text = [self.managedObject valueForKey:@"sparesRequired"];
   
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
    
    // TODO: Add in name values
    [self.managedObject setValue:[NSString checkForNilString:self.additionalNotesTextView.text] forKey:@"additionalNotes"];
    [self.managedObject setValue:[NSString checkForNilString:self.sparesRequiredTextView.text] forKey:@"sparesRequired"];
 
    
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
