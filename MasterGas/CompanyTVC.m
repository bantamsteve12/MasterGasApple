//
//  CompanyTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 20/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "CompanyTVC.h"
#import "SDCoreDataController.h"
//#import "SDSyncEngine.h"
#import "Customer.h"
#import "LACHelperMethods.h"


@interface CompanyTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@end

@implementation CompanyTVC

@synthesize popoverController;
@synthesize imagePicker;
@synthesize entityName;

@synthesize companyLogoImageView;
@synthesize rawCameraImage;
@synthesize companyNameTextField;
@synthesize companyAddressLine1TextField;
@synthesize companyAddressLine2TextField;
@synthesize companyAddressLine3TextField;
@synthesize companyPostcodeTextField;
@synthesize companyTelTextField;
@synthesize companyMobileNumberTextField;
@synthesize companyEmailAddressTextField;
@synthesize companyGSRNumberTextField;
@synthesize companyVATRegNoTextField;
@synthesize standardCompanyVatAmount;
@synthesize companiesHouseCompanyNumberTextField;
@synthesize currencyTextField;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize companyRecords;
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
    self.companyGSRNumberTextField.text = [self.managedObject valueForKey:@"companyGSRNumber"];
    self.companyVATRegNoTextField.text = [self.managedObject valueForKey:@"companyVATNumber"];
    
    self.standardCompanyVatAmount.text = [self.managedObject valueForKey:@"standardCompanyVatAmount"];
    

    self.companiesHouseCompanyNumberTextField.text = [self.managedObject valueForKey:@"companyCompaniesHouseRegNumber"];
    
    
    NSString *currencySymbol = [self.managedObject valueForKey:@"defaultCurrency"];
    
    if (currencySymbol.length > 0) {
        self.currencyTextField.text = [self.managedObject valueForKey:@"defaultCurrency"];
    }
    else{
        self.currencyTextField.text = @"£";
    }
    
    
    
    
    self.companyLogoImageView.image = [LACFileHandler getImageFromDocumentsDirectory:@"logo.png" subFolderName:@"system"];
    
 }

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        
        NSLog(@"entity: %@", self.entityName);
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
   //     [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
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


- (IBAction)saveButtonTouched:(id)sender {
    
    
    if (![self.companyNameTextField.text isEqualToString:@""]) {
        [self.managedObject setValue:self.companyNameTextField.text forKey:@"companyName"];
        [self.managedObject setValue:self.companyAddressLine1TextField.text forKey:@"companyAddressLine1"];
        [self.managedObject setValue:self.companyAddressLine2TextField.text forKey:@"companyAddressLine2"];
        [self.managedObject setValue:self.companyAddressLine3TextField.text forKey:@"companyAddressLine3"];
        [self.managedObject setValue:self.companyPostcodeTextField.text forKey:@"companyPostcode"];
        [self.managedObject setValue:self.companyTelTextField.text forKey:@"companyTelNumber"];
        [self.managedObject setValue:self.companyMobileNumberTextField.text forKey:@"companyMobileNumber"];
        [self.managedObject setValue:self.companyEmailAddressTextField.text forKey:@"companyEmailAddress"];
        [self.managedObject setValue:self.companyGSRNumberTextField.text forKey:@"companyGSRNumber"];
        [self.managedObject setValue:self.companyVATRegNoTextField.text forKey:@"companyVATNumber"];
        [self.managedObject setValue:self.standardCompanyVatAmount.text forKey:@"standardCompanyVatAmount"];
        
        [self.managedObject setValue:self.currencyTextField.text forKey:@"defaultCurrency"];
        
           [self.managedObject setValue:self.companiesHouseCompanyNumberTextField.text forKey:@"companyCompaniesHouseRegNumber"];
        
        [LACHelperMethods setCompanyStandardVatRate:self.standardCompanyVatAmount.text];
        
        
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
      //  updateCompletionBlock();
        
    } else {
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Company Name Required" message:@"You must at least set a company name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cannotSaveAlert show];
    }
    
    NSData *pngData = UIImagePNGRepresentation(self.companyLogoImageView.image);
    [LACFileHandler saveFileInDocumentsDirectory:@"logo.png" subFolderName:@"system" withData:pngData];
    
    [LACHelperMethods setUserPreferencesInNSDefaults:self.managedObjectContext];
 
    }


-(IBAction)setCompanyLogo:(id)sender
{
    
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(300, 100);
    self.imagePicker.delegate = self;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
      
        
        [self.popoverController presentPopoverFromRect:self.companyLogoImageView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        
        CGRect r=((UIButton*)sender).frame;
        CGRect tRect=[((UIButton*)sender) convertRect:((UIButton*)sender).frame toView:self.view];
        tRect.origin.x=r.origin.x;
        
        [self.popoverController presentPopoverFromRect:tRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
        
    } else {
        
        [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
        
    }

    
}


-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissModalViewControllerAnimated:YES];
    rawCameraImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.companyLogoImageView.image = rawCameraImage;
}


#pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    self.companyLogoImageView.image = image;
   
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
     [self.popoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [self hideImagePicker];
    }
}



- (void)hideImagePicker{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        
    }
}


# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    self.companyLogoImageView.image = image;
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    } else {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
