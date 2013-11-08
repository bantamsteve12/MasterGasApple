//
//  ReminderGSRLetterPDFViewController.m
//  MasterGas
//
//  Created by Stephen Lalor on 20/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "ReminderGSRLetterPDFViewController.h"
#import "CoreText/CoreText.h"
#import "ReminderGSRLetterRenderer.h"
#import <Dropbox/Dropbox.h>
#import "LACFileHandler.h"
#import "LACHelperMethods.h"
#import "SDCoreDataController.h"

@interface ReminderGSRLetterPDFViewController ()

@end

@implementation ReminderGSRLetterPDFViewController

@synthesize webView;
@synthesize currentCertificate;
@synthesize applianceInspections;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize mode;
@synthesize aCertificate;


- (void)loadRecordsFromCoreData {
    
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ApplianceInspection"];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES]]];
        
        [request setPredicate:[NSPredicate predicateWithFormat:@"(syncStatus != %d) AND (certificateReference == %@)", SDObjectDeleted, self.currentCertificate.certificateNumber]];
        
        
        self.applianceInspections = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        NSLog(@"1. appliance inspections = %i", self.applianceInspections.count);
    }];
}

- (void)loadCompanyRecordFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        //   [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Company"];
        
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        self.companyRecords = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



-(void)generatingHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Generating";
    
	[HUD showWhileExecuting:@selector(generateCertificate) onTarget:self withObject:nil animated:YES];
}



-(void)uploadToDropbox
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Uploading";
	
	[HUD showWhileExecuting:@selector(saveToDropbox) onTarget:self withObject:nil animated:YES];
}

-(void)saveToDropbox
{
    NSString *pdfPath = [self getPDFFileName];
    
    NSData *myData = [NSData dataWithContentsOfFile:pdfPath];
    
    NSString *filename = [NSString stringWithFormat:@"%@%@.pdf", @"REM", currentCertificate.certificateNumber];
    
    [LACFileHandler saveFileInDocumentsDirectory:filename subFolderName:@"Uploads" withData:myData];
    
    sleep(2);
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Completed";
    sleep(2);
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  
    
    
    [self generatingHUD];
    [super viewDidLoad];
}


-(void)generateCertificate
{
    aCertificate = currentCertificate;
    
    // applianceInspections = [[NSMutableArray alloc] init];
    
    //[self loadRecordsFromCoreData];
    
    [self loadRecordsFromCoreData];
    [self loadCompanyRecordFromCoreData];
    
    
    NSString* fileName = [self getPDFFileName];
    
    
    NSMutableArray *applianceInpects = [NSMutableArray arrayWithArray:self.applianceInspections];
    
    // Could probably tidy up in a future release to use type def
    NSString *certificateReportLayoutName = @"LandlordGasSafetyRecordReminderLetter";

    [ReminderGSRLetterRenderer drawPDF:fileName withCertificate:aCertificate withInspection:applianceInpects withCertificateReportLayoutName:certificateReportLayoutName withCompanyRecord:[self.companyRecords objectAtIndex:0]];
                                                                                                                                                        
    [self showPDFFile];
    
    if ([self.mode isEqualToString:@"print"]) {
        [self print:[self getPDFFileName]];
    }
    else if ([self.mode isEqualToString:@"email"])
    {
        [self emailToCustomer];
    }
    else if ([self.mode isEqualToString:@"dropbox"])
    {
        NSLog(@"dropbox");
        [self uploadToDropbox];
        
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.applianceInspections = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)actionsButonPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Actions"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Email", @"Print", @"Send to Dropbox"
                                  ,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromToolbar:self.tabBarController.tabBar];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	// Email
	if(buttonIndex == 0){
        [self emailToCustomer];
	}
	// Print
	if (buttonIndex == 1){
        [self print:[self getPDFFileName]];
	}
    // Dropbox
    if (buttonIndex == 2) {
        
        DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
        
        if (!account.linked) {
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Dropbox not linked"
                                  message:@"Link to your dropbox account in Settings -> Dropbox Integration"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            
            [alert show];
            
        }
        else
        {
            [self uploadToDropbox];
        }
    }
    
}

-(void)print:(NSString *)filePath
{
    
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    UIPrintInteractionController *print = [UIPrintInteractionController sharedPrintController];
    
    print.delegate = self;
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = [filePath lastPathComponent];
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    printInfo.orientation = UIPrintInfoOrientationLandscape;
    print.printInfo = printInfo;
    print.showsPageRange = YES;
    print.printingItem = myData;
    UIViewPrintFormatter *viewFormatter = [self.view viewPrintFormatter];
    viewFormatter.startPage = 0;
    print.printFormatter = viewFormatter;
    
    UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {};
    
    [print presentAnimated:YES completionHandler:completionHandler];
}


-(void)emailToCustomer
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Annual Gas Safety Reminder Letter Attached"];
    
    // Set up recipients
    if ([aCertificate.customerEmail length] > 0) {
        NSArray *toRecipients = [NSArray arrayWithObject:aCertificate.customerEmail];
        [picker setToRecipients:toRecipients];
    }
    
    NSString *bccEmail = [prefs valueForKey:@"bccEMailAddress"];
    if ([bccEmail length] > 0) {
        NSArray *toBCCRecipients = [NSArray arrayWithObject:bccEmail];
        [picker setBccRecipients:toBCCRecipients];
    }
    
    NSString *ccEmail = [prefs valueForKey:@"ccEmailAddress"];
    if ([ccEmail length] > 0) {
        NSArray *toCCRecipients = [NSArray arrayWithObject:ccEmail];
        [picker setCcRecipients:toCCRecipients];
    }
    
    
    NSData * pdfData = [NSData dataWithContentsOfFile:[self getPDFFileName]];
    [picker addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@%@.pdf",@"REM", aCertificate.certificateNumber]];
    
    [picker setMessageBody:@"Please find attached your Annual Gas Safety Certificate reminder letter." isHTML:NO];
    
    [self presentModalViewController:picker animated:YES];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)showPDFFile
{
    NSString* pdfFileName = [self getPDFFileName];
    
    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:request];
    [self.view addSubview:webView];
    
}

-(NSString*)getPDFFileName
{
    NSString* fileName = [NSString stringWithFormat:@"%@%@.pdf", @"REM", aCertificate.certificateNumber];
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    return pdfFileName;
    
}

@end
