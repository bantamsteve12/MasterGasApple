//
//  SetupStepTwoTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 08/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "SetupStepTwoTVC.h"
#import "CompanyTVC.h"
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"
#import "LACHelperMethods.h"

@interface SetupStepTwoTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@end

@implementation SetupStepTwoTVC

@synthesize popoverController;
@synthesize entityName;

@synthesize companyLogoImageView;
@synthesize rawCameraImage;
@synthesize companyGSRNumberTextField;
@synthesize companyVATRegNoTextField;
@synthesize companiesHouseCompanyNumberTextField;
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
    
    self.companyGSRNumberTextField.text = [self.managedObject valueForKey:@"companyGSRNumber"];
    self.companyVATRegNoTextField.text = [self.managedObject valueForKey:@"companyVATNumber"];
        self.companiesHouseCompanyNumberTextField.text = [self.managedObject valueForKey:@"companyCompaniesHouseRegNumber"];
    
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SetupStepThreeSegue"]) {
        [self.managedObject setValue:self.companyGSRNumberTextField.text forKey:@"companyGSRNumber"];
        [self.managedObject setValue:self.companyVATRegNoTextField.text forKey:@"companyVATNumber"];
    
        [self.managedObject setValue:@"20.00"forKey:@"standardCompanyVatAmount"];
        [LACHelperMethods setCompanyStandardVatRate:@"20.00"];
        
        [self.managedObject setValue:self.companiesHouseCompanyNumberTextField.text forKey:@"companyCompaniesHouseRegNumber"];
        
        [self.managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            BOOL saved = [self.managedObjectContext save:&error];
            if (!saved) {
                // do some real error handling
                NSLog(@"Could not save Date due to %@", error);
            }
            [[SDCoreDataController sharedInstance] saveMasterContext];
        }];
        
        
        NSData *pngData = UIImagePNGRepresentation(self.companyLogoImageView.image);
        [LACFileHandler saveFileInDocumentsDirectory:@"logo.png" subFolderName:@"system" withData:pngData];
        
        [LACHelperMethods setUserPreferencesInNSDefaults:self.managedObjectContext];

    }
}


-(IBAction)setCompanyLogo:(id)sender
{ self.imagePicker = [[GKImagePicker alloc] init];
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
    
    //[self makeUIImagePickerControllerForCamera:NO];
}


- (void) makeUIImagePickerControllerForCamera:(BOOL)camera {
   
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(300, 100);
    self.imagePicker.delegate = self;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
     //   NSLog(@"frame:%@", self.companyLogoImageView.frame );
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
      //  [self.popoverController presentPopoverFromRect:self.companyLogoImageView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
         [self.popoverController presentPopoverFromRect:CGRectMake(0, 0, 200, 200) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
       
        
    } else {
        
        [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
        
    }

    
}


-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissModalViewControllerAnimated:YES];
    rawCameraImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.companyLogoImageView.image = rawCameraImage;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.popoverController dismissPopoverAnimated:YES];
    }
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
    
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
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


- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
