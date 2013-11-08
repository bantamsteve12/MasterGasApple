//
//  EngineerDetailTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 21/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "EngineerDetailTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "LACFileHandler.h"
#import "NSString+Additions.h"

@interface EngineerDetailTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@end

@implementation EngineerDetailTVC

@synthesize entityName;
@synthesize signatureView;
@synthesize engineerNameTextField;
@synthesize engineerGSRIDNumberTextField;
@synthesize engineerActive;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;

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
    
    if (self.managedObjectId == nil) {
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
        
        [self.managedObject setValue:[NSString stringWithFormat:@"ENG-%@", [NSString generateUniqueNumberIdentifier]]forKey:@"engineerId"];
          [self.engineerActive setOn:YES];
    }
    else{
        self.managedObject = [managedObjectContext objectWithID:self.managedObjectId];
   
        self.engineerNameTextField.text = [self.managedObject valueForKey:@"engineerName"];
        self.engineerGSRIDNumberTextField.text = [self.managedObject valueForKey:@"engineerGSRIDNumber"];
        
        
        NSString *imageName = [self.managedObject valueForKey:@"engineerSignatureFilename"];
        self.signatureView.image = [LACFileHandler getImageFromDocumentsDirectory:imageName subFolderName:@"system"];
        
        
        if ([[self.managedObject valueForKey:@"active"] isEqualToString:@"Yes"] ) {
            [self.engineerActive setOn:YES];
        }
        else
        {
            [self.engineerActive setOn:NO];
        }
    }
  }




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}



- (IBAction)saveButtonTouched:(id)sender {
    
    
    if (![self.engineerNameTextField.text isEqualToString:@""]) {
        
        
        [self.managedObject setValue:self.engineerNameTextField.text forKey:@"engineerName"];
        [self.managedObject setValue:self.engineerGSRIDNumberTextField.text forKey:@"engineerGSRIDNumber"];
        
        if (engineerActive.isOn) {
            [self.managedObject setValue:@"Yes" forKey:@"active"];
        }
        else
        {
            [self.managedObject setValue:@"No" forKey:@"active"];
        }
        
        NSString *filename =  [NSString stringWithFormat:@"eng-%@.png",[self.managedObject valueForKey:@"engineerId"]];
        
        NSData *pngData = UIImagePNGRepresentation(self.signatureView.image);
        [LACFileHandler saveFileInDocumentsDirectory:filename subFolderName:@"system" withData:pngData];
        
        [self.managedObject setValue:filename forKey:@"engineerSignatureFilename"];
       
        //NSString *objectId = [self.managedObject valueForKey:@"objectId"];
        
        /*
        if (objectId.length > 1) {
            [self.managedObject setValue:[NSNumber numberWithInt:SDObjectEdited] forKey:@"syncStatus"];
        }
        else
        {
            [self.managedObject setValue:[NSNumber numberWithInt:SDObjectCreated] forKey:@"syncStatus"];
        } */
        
        
        
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
       /// updateCompletionBlock();
        
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
        
        NSLog(@"%@", filename);
        
        //signature.signatureImage = signatureImageView.image;
        
        signature.delegate = self;
    }
}


-(void)theAcceptButtonWasPressedOnTheSignature:(Signature *)controller
{
    self.signatureView.image = controller.signatureImage;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
