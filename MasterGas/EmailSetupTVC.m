//
//  EmailSetupTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 11/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "EmailSetupTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "LACHelperMethods.h"

@interface EmailSetupTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@end

@implementation EmailSetupTVC

@synthesize entityName;


@synthesize ccEmailAddressTextField;
@synthesize bccEmailAddressTextField;
@synthesize certificateBodyTextTextViewField;
@synthesize invoiceBodyTextTextViewField;

@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize emailRecords;
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
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
    [self loadRecordsFromCoreData];
    
    if (self.emailRecords.count < 1) {
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    }
    else{
        self.managedObject = [self.emailRecords objectAtIndex:0];
    }
    
    self.ccEmailAddressTextField.text = [self.managedObject valueForKey:@"ccEmailAddress"];
    self.bccEmailAddressTextField.text = [self.managedObject valueForKey:@"bccEMailAddress"];
    self.certificateBodyTextTextViewField.text = [self.managedObject valueForKey:@"certificateBodyText"];
    self.invoiceBodyTextTextViewField.text = [self.managedObject valueForKey:@"invoiceBodyText"];
    
}

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        
        NSLog(@"entity: %@", self.entityName);
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"companyId" ascending:YES]]];
     //   [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        self.emailRecords = [self.managedObjectContext executeFetchRequest:request error:&error];
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


- (IBAction)saveButtonTouched:(id)sender {
    
    
        [self.managedObject setValue:self.ccEmailAddressTextField.text forKey:@"ccEmailAddress"];
        [self.managedObject setValue:self.bccEmailAddressTextField.text forKey:@"bccEMailAddress"];
        [self.managedObject setValue:self.certificateBodyTextTextViewField.text forKey:@"certificateBodyText"];
        [self.managedObject setValue:self.invoiceBodyTextTextViewField.text forKey:@"invoiceBodyText"];
    
        
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
       // updateCompletionBlock();
    
    [LACHelperMethods setEmailPreferencesInNSDefaults:self.managedObjectContext];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
