#import "SendReminderTVC.h"
#import "ReminderGSRLetterPDFViewController.h"
#import "ServiceLetterPDFViewController.h"
#import "SDCoreDataController.h"

@interface SendReminderTVC ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@end

@implementation SendReminderTVC

@synthesize applianceItems;
@synthesize certicate;
@synthesize maintenanceServiceCheck;
@synthesize maintenanceServiceRecord;

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
    
    NSLog(@"certificate: %@", self.certicate);
    
}


- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PreviewLetterSegue"]) {
        ReminderGSRLetterPDFViewController *reminderGSRLetterPDFViewController = segue.destinationViewController;
        reminderGSRLetterPDFViewController.mode = @"view";
        reminderGSRLetterPDFViewController.currentCertificate = self.certicate;
    }
    else if ([segue.identifier isEqualToString:@"EmailLetterSegue"]) {
        ReminderGSRLetterPDFViewController *reminderGSRLetterPDFViewController = segue.destinationViewController;
        reminderGSRLetterPDFViewController.mode = @"email";
        reminderGSRLetterPDFViewController.currentCertificate = self.certicate;
    }
    else if ([segue.identifier isEqualToString:@"PreviewServiceLetterSegue"]) {
        ServiceLetterPDFViewController *serviceLetterPDFViewController = segue.destinationViewController;
        serviceLetterPDFViewController.mode = @"view";
    
        if (self.maintenanceServiceCheck != nil) {
            serviceLetterPDFViewController.currentMaintenanceServiceCheck = self.maintenanceServiceCheck;
        }
        else if (self.maintenanceServiceRecord != nil) {
            serviceLetterPDFViewController.currentMaintenanceServiceRecord = self.maintenanceServiceRecord;
        }
    }
    else if ([segue.identifier isEqualToString:@"EmailServiceLetterSegue"]) {
        ServiceLetterPDFViewController *serviceLetterPDFViewController = segue.destinationViewController;
        serviceLetterPDFViewController.mode = @"email";
        
        if (self.maintenanceServiceCheck != nil) {
            serviceLetterPDFViewController.currentMaintenanceServiceCheck = self.maintenanceServiceCheck;
        }
        else if (self.maintenanceServiceRecord != nil) {
            serviceLetterPDFViewController.currentMaintenanceServiceRecord = self.maintenanceServiceRecord;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select row at index path");
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
    if (cell.tag == 8) {
        // TODO: set correct segues
        if (self.certicate != nil) {
            [self performSegueWithIdentifier:@"EmailLetterSegue" sender:nil];
        }
        else
        {
            [self performSegueWithIdentifier:@"EmailServiceLetterSegue" sender:nil];
        }
    }
    else if (cell.tag == 9) {
        // TODO: set correct segues
        if (self.certicate != nil) {
            [self performSegueWithIdentifier:@"PreviewLetterSegue" sender:nil];
        }
        else
        {
            [self performSegueWithIdentifier:@"PreviewServiceLetterSegue" sender:nil];
        }
    }
    
}


- (void)loadApplianceItemsDataFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        //    [self.applianceManagedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ApplianceInspection"];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES]]];
        
        [request setPredicate:[NSPredicate predicateWithFormat:@"(certificateReference == %@)",     self.certicate.certificateNumber]];
        
        self.applianceItems = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}


-(IBAction)sendSMSReminderButtonPressed:(id)sender
{
  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMMM yyyy"];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 12;
    NSDate *oneMonthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:certicate.date options:0];
    
    [dateFormatter stringFromDate:oneMonthFromNow];
  
    
    if (self.certicate != nil) {
        [self sendSMSTextMessage:self.certicate.customerMobileNumber withMessage:[NSString stringWithFormat:@"%@ is due a Gas Landlord Safety check before %@. Contact us to arrange a visit.", certicate.siteAddressLine1, [dateFormatter stringFromDate:oneMonthFromNow]]];
    }
    else if(self.maintenanceServiceCheck != nil) {
         [self sendSMSTextMessage:self.certicate.customerMobileNumber withMessage:[NSString stringWithFormat:@"%@ is due an annual Gas Maintenance Service Check before %@. Contact us to arrange a visit.", certicate.siteAddressLine1, [dateFormatter stringFromDate:oneMonthFromNow]]];
    }
    else if(self.maintenanceServiceRecord != nil) {
        [self sendSMSTextMessage:self.certicate.customerMobileNumber withMessage:[NSString stringWithFormat:@"%@ is due an annual Gas Maintenance Service Check before %@. Contact us to arrange a visit.", certicate.siteAddressLine1, [dateFormatter stringFromDate:oneMonthFromNow]]];
    }
}


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


-(void)sendSMSTextMessage:(NSString *)telephoneNumber withMessage:(NSString *)message
{
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            
            controller.body = message;
            
            if (telephoneNumber.length > 0) {
                
                NSString *telNo = telephoneNumber;
                
                // strip out any non numbers.
                NSMutableString *strippedStringTel = [NSMutableString
                                                      stringWithCapacity:telNo.length];
                
                NSScanner *scanner = [NSScanner scannerWithString:telNo];
                NSCharacterSet *numbers = [NSCharacterSet
                                           characterSetWithCharactersInString:@"0123456789"];
                
                while ([scanner isAtEnd] == NO) {
                    NSString *buffer;
                    if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
                        [strippedStringTel appendString:buffer];
                    } else {
                        [scanner setScanLocation:([scanner scanLocation] + 1)];
                    }
                }
                
                controller.recipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",telephoneNumber], nil];
                controller.messageComposeDelegate = self;
                [self presentModalViewController:controller animated:YES];
            }
            else
            {
                UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"A valid number is not entered in the mobile number field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [Notpermitted show];
            }
            
        }
    }
    else
    {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}



// Launches the Mail application on the device. Workaround
-(void)launchMailAppOnDevice:(NSString *)body{
	NSString *recipients = [NSString stringWithFormat:@"mailto:%@?subject=%@", self.certicate.customerEmail, @""];
	
    NSString *mailBody = [NSString stringWithFormat:@"&body=%@", body];
    
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, mailBody];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

// Call this method and pass parameters
-(void) showComposer:(id)sender{
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil){
       // [self launchMailAppOnDevice:sender];
        [self launchMailAppOnDevice:@""];
	}
    else
    {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support the email feature. Please try setting up your emails in the Settings App on your device." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}


-(IBAction)sendEmailButtonPressed:(id)sender
{
    [self showComposer:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end