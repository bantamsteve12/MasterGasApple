//
//  CustomerSignoffTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 01/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "CustomerSignoffTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"


@interface CustomerSignoffTVC ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property CGPoint originalCenter;
@end

@implementation CustomerSignoffTVC

@synthesize signatureImageView;
@synthesize entityName;
@synthesize customerPositionTextField;
@synthesize customerSignOffNameTextField;
@synthesize customerSignoffDateLabel;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize dateFormatter;
@synthesize companyRecords;

@synthesize certificateReferenceNumber;

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
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
  //  [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.dateFormatter setDateFormat:@"d MMMM yyyy"];
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
    self.signatureImageView.image = [LACFileHandler getImageFromDocumentsDirectory:[self.managedObject valueForKey:@"customerSignatureFilename"] subFolderName:@"signatures"];

    
    NSLog(@"customerSignatureFilename = %@", [self.managedObject valueForKey:@"customerSignatureFilename"]);
    
    // load values if present
    self.customerSignOffNameTextField.text = [self.managedObject valueForKey:@"customerSignoffName"];
    self.customerPositionTextField.text = [self.managedObject valueForKey:@"customerPosition"];
    
    // set default value date if required.
    NSDate *customerSignOffDate = [self.managedObject valueForKey:@"customerSignoffDate"];
    
    if (customerSignOffDate == nil) {
        
        [self.managedObject setValue:[NSDate date] forKey:@"customerSignoffDate"];
        self.customerSignoffDateLabel.text = [self.dateFormatter stringFromDate:[self.managedObject valueForKey:@"customerSignoffDate"]];
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"d MMMM yyyy"];

        NSString *dateLabelString = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:customerSignOffDate]];
        self.customerSignoffDateLabel.text = dateLabelString;
    }
}


- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (void)loadCompanyRecordFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Company"];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        self.companyRecords = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}

- (IBAction)cancelButtonPressed:(id)sender
{
    NSLog(@"Cancel button pressed");
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveButtonTouched:(id)sender {
            
    [self.managedObject setValue:[NSString checkForNilString:self.customerSignOffNameTextField.text] forKey:@"customerSignoffName"];
    [self.managedObject setValue:[NSString checkForNilString:self.customerPositionTextField.text] forKey:@"customerPosition"];
  
   // TODO set date
   // TODO set signature
    
    NSString *objectId = [self.managedObject valueForKey:@"objectId"];
    
    if (objectId.length > 1) {
        [self.managedObject setValue:[NSNumber numberWithInt:SDObjectEdited] forKey:@"syncStatus"];
    }
    else
    {
        [self.managedObject setValue:[NSNumber numberWithInt:SDObjectCreated] forKey:@"syncStatus"];
    }
    
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


-(void)theAcceptButtonWasPressedOnTheSignature:(Signature *)controller
{    
    NSString *customerSignatureFilename = [NSString stringWithFormat:@"cust-sign-%@.png", certificateReferenceNumber];
    
    self.signatureImageView.image = controller.signatureImage;
    [self.managedObject setValue:customerSignatureFilename forKey:@"customerSignatureFilename"];
  
    NSData *pngData = UIImagePNGRepresentation(controller.signatureImage);
    [LACFileHandler saveFileInDocumentsDirectory:customerSignatureFilename subFolderName:@"signatures" withData:pngData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)theCancelButtonWasPressedOnTheSignature:(Signature *)controller
{
    // TODO
}


-(void)theCustomerPositionWasSelectedFromTheList:(CustomerPositionLookupTVC *)controller
{
    self.customerPositionTextField.text = controller.selectedCustomerPosition.name;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SignatureSegue"]) {
        Signature *signature = segue.destinationViewController;
      
        NSString *filename = [NSString stringWithFormat:@"cust-%@.png", self.certificateReferenceNumber];
        signature.imageName = filename;
      
        NSLog(@"%@", filename);
        
        signature.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"CustomerPositionSegue"]) {
        CustomerPositionLookupTVC *customerPositionLookup = segue.destinationViewController;
        customerPositionLookup.delegate = self;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
