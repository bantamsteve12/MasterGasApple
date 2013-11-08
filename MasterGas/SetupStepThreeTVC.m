//
//  SetupStepThreeTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 10/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "SetupStepThreeTVC.h"
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"
#import "LACFileHandler.h"
#import "TabBarController.h"
#import "NSString+Additions.h"

@interface SetupStepThreeTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@end

@implementation SetupStepThreeTVC

@synthesize entityName;
@synthesize signatureView;
@synthesize engineerNameTextField;
@synthesize engineerGSRIDNumberTextField;
@synthesize engineerActive;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;


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
    
    if (self.managedObjectId == nil) {
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
           [self.managedObject setValue:[NSString stringWithFormat:@"ENG-%@", [NSString generateUniqueNumberIdentifier]]forKey:@"engineerId"];
    }
    else{
        self.managedObject = [managedObjectContext objectWithID:self.managedObjectId];
    }
    
    self.engineerNameTextField.text = [self.managedObject valueForKey:@"engineerName"];
    self.engineerGSRIDNumberTextField.text = [self.managedObject valueForKey:@"engineerGSRIDNumber"];
    
    
    NSString *imageName = [self.managedObject valueForKey:@"engineerSignatureFilename"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName]; //Add the file name
    
    self.signatureView.image = [[UIImage alloc] initWithContentsOfFile:filePath];
    
    
    
    
    if ([[self.managedObject valueForKey:@"active"] isEqualToString:@"Yes"] ) {
        [self.engineerActive setOn:YES];
    }
    else
    {
        [self.engineerActive setOn:NO];
    }
}




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}


- (IBAction)saveButtonTouched:(id)sender {
    
    if (![self.engineerNameTextField.text isEqualToString:@""]) {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setBool:NO forKey:@"NewRegistration"];
        [prefs synchronize];

        [self.managedObject setValue:self.engineerNameTextField.text forKey:@"engineerName"];
        [self.managedObject setValue:self.engineerGSRIDNumberTextField.text forKey:@"engineerGSRIDNumber"];
        [self.managedObject setValue:@"Yes" forKey:@"active"];
        
        NSString *filename =  [NSString stringWithFormat:@"eng-%@.png",[self.managedObject valueForKey:@"engineerId"]];
        
        NSData *pngData = UIImagePNGRepresentation(self.signatureView.image);
        [LACFileHandler saveFileInDocumentsDirectory:filename subFolderName:@"system" withData:pngData];
        
        [self.managedObject setValue:filename forKey:@"engineerSignatureFilename"];
        
     
        [self.managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            BOOL saved = [self.managedObjectContext save:&error];
            if (!saved) {
                // do some real error handling
                NSLog(@"Could not save Date due to %@", error);
            }
            [[SDCoreDataController sharedInstance] saveMasterContext];
        }];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    
    } else {
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"You must at least set a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cannotSaveAlert show];
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SignatureSegue"]) {
        Signature *signature = segue.destinationViewController;
        
        
        NSString *filename = [NSString stringWithFormat:@"eng-%@.png",[self.managedObject valueForKey:@"engineerId"]];
        signature.imageName = filename;
        
              
        NSLog(@"signature saved filename: %@", filename);
        
        //signature.signatureImage = signatureImageView.image;
        
        signature.delegate = self;
    }
}


-(void)theAcceptButtonWasPressedOnTheSignature:(Signature *)controller
{
    self.signatureView.image = controller.signatureImage;
    
      NSString *filename = [NSString stringWithFormat:@"eng-%@.png",[self.managedObject valueForKey:@"engineerId"]];
    
    NSData *pngData = UIImagePNGRepresentation(self.signatureView.image);
    [LACFileHandler saveFileInDocumentsDirectory:filename subFolderName:@"system" withData:pngData];
    
    [self.navigationController popViewControllerAnimated:YES];
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
