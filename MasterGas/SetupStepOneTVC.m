//
//  SetupStepOneTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 08/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "SetupStepOneTVC.h"
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"
#import "Customer.h"
#import "LACHelperMethods.h"

@interface SetupStepOneTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@end

@implementation SetupStepOneTVC

@synthesize entityName;


@synthesize companyNameTextField;
@synthesize companyAddressLine1TextField;
@synthesize companyAddressLine2TextField;
@synthesize companyAddressLine3TextField;
@synthesize companyPostcodeTextField;
@synthesize companyTelTextField;
@synthesize companyMobileNumberTextField;
@synthesize companyEmailAddressTextField;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize companyRecords;
@synthesize updateCompletionBlock;


bool companyNameEntered;

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
    
    [self loadRecordsFromCoreData];
    
    if (self.companyRecords.count < 1) {
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    }
    else{
        self.managedObject = [self.companyRecords objectAtIndex:0];
    }
        
    self.companyNameTextField.text = [self.managedObject valueForKey:@"companyName"];
    self.companyAddressLine1TextField.text  = [self.managedObject valueForKey:@"companyAddressLine1"];
    self.companyAddressLine2TextField.text = [self.managedObject valueForKey:@"companyAddressLine2"];
    self.companyAddressLine3TextField.text = [self.managedObject valueForKey:@"companyAddressLine3"];
    self.companyPostcodeTextField.text = [self.managedObject valueForKey:@"companyPostcode"];
    self.companyTelTextField.text = [self.managedObject valueForKey:@"companyTelNumber"];
    self.companyMobileNumberTextField.text = [self.managedObject valueForKey:@"companyMobileNumber"];
    self.companyEmailAddressTextField.text = [self.managedObject valueForKey:@"companyEmailAddress"];
}

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        
        NSLog(@"entity: %@", self.entityName);
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        self.companyRecords = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //  self.originalCenter = self.view.center;
}


-(IBAction)cancelButtonTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)nextButtonTouched:(id)sender {
    
    
    if (![self.companyNameTextField.text isEqualToString:@""]) {
        
        companyNameEntered = YES;
        
        [self.managedObject setValue:self.companyNameTextField.text forKey:@"companyName"];
        [self.managedObject setValue:self.companyAddressLine1TextField.text forKey:@"companyAddressLine1"];
        [self.managedObject setValue:self.companyAddressLine2TextField.text forKey:@"companyAddressLine2"];
        [self.managedObject setValue:self.companyAddressLine3TextField.text forKey:@"companyAddressLine3"];
        [self.managedObject setValue:self.companyPostcodeTextField.text forKey:@"companyPostcode"];
        [self.managedObject setValue:self.companyTelTextField.text forKey:@"companyTelNumber"];
        [self.managedObject setValue:self.companyMobileNumberTextField.text forKey:@"companyMobileNumber"];
        [self.managedObject setValue:self.companyEmailAddressTextField.text forKey:@"companyEmailAddress"];
    
        
        [self.managedObject setValue:@"20.00"forKey:@"standardCompanyVatAmount"];
        
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
        updateCompletionBlock();
        
    }
    
 
    [LACHelperMethods setUserPreferencesInNSDefaults:self.managedObjectContext];
    
}




- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"SetupStepTwoSegue"]) {
        // perform your computation to determine whether segue should occur
        
        BOOL segueShouldOccur = NO; // you determine this
        
        if (self.companyNameTextField.text.length > 0) {
            segueShouldOccur = YES;
        }
        else
        {
            UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Company Name Required" message:@"You must at least set a company name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [cannotSaveAlert show];

            
            return NO;
        }
    }
    
    // by default perform the segue transition
    return YES;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SetupStepTwoSegue"]) {
 
        if (![self.companyNameTextField.text isEqualToString:@""]) {
            [self.managedObject setValue:self.companyNameTextField.text forKey:@"companyName"];
            [self.managedObject setValue:self.companyAddressLine1TextField.text forKey:@"companyAddressLine1"];
            [self.managedObject setValue:self.companyAddressLine2TextField.text forKey:@"companyAddressLine2"];
            [self.managedObject setValue:self.companyAddressLine3TextField.text forKey:@"companyAddressLine3"];
            [self.managedObject setValue:self.companyPostcodeTextField.text forKey:@"companyPostcode"];
            [self.managedObject setValue:self.companyTelTextField.text forKey:@"companyTelNumber"];
            [self.managedObject setValue:self.companyMobileNumberTextField.text forKey:@"companyMobileNumber"];
            [self.managedObject setValue:self.companyEmailAddressTextField.text forKey:@"companyEmailAddress"];
            
          
            
            [self.managedObjectContext performBlockAndWait:^{
                NSError *error = nil;
                BOOL saved = [self.managedObjectContext save:&error];
                if (!saved) {
                    // do some real error handling
                    NSLog(@"Could not save Date due to %@", error);
                }
                [[SDCoreDataController sharedInstance] saveMasterContext];
            }];
        
            
        } else {
            UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Company Name Required" message:@"You must at least set a company name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [cannotSaveAlert show];
        }
        
        
        [LACHelperMethods setUserPreferencesInNSDefaults:self.managedObjectContext];
        
        
    }
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
