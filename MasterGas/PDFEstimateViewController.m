//
//  PDFEstimateViewController.m
//  MasterGas
//
//  Created by Stephen Lalor on 23/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "PDFEstimateViewController.h"
#import "CoreText/CoreText.h"
#import "PDFEstimateRenderer.h"
#import "Company.h"

@interface PDFEstimateViewController ()

@end

@implementation PDFEstimateViewController


@synthesize webView;
@synthesize currentEstimate;
@synthesize estimateItems;
@synthesize companyRecords;
@synthesize managedObjectContext;
@synthesize managedObject;

@synthesize mode;
@synthesize aEstimate;

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        //   [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"EstimateItem"];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"itemDescription" ascending:YES]]];
        
        [request setPredicate:[NSPredicate predicateWithFormat:@"(estimateNo == %@)", self.currentEstimate.uniqueEstimateNo]];
        
        self.estimateItems = [self.managedObjectContext executeFetchRequest:request error:&error];
     
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

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

-(void)generatingHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Generating";
	
    [HUD showWhileExecuting:@selector(generateCertificate) onTarget:self withObject:nil animated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self generatingHUD];
    [super viewDidLoad];
}


-(void)generateCertificate
{
    aEstimate = currentEstimate;
    estimateItems = [[NSMutableArray alloc] init];
    
    [self loadRecordsFromCoreData];
    [self loadCompanyRecordFromCoreData];
    
    NSString* fileName = [self getPDFFileName];
    NSMutableArray *estimateItemsMutableArray = [NSMutableArray arrayWithArray:estimateItems];
    Company *companyRecord = [self.companyRecords objectAtIndex:0];
    
    [PDFEstimateRenderer drawPDF:fileName withEstimate:aEstimate withEstimateItems:estimateItemsMutableArray withCompanyRecord:companyRecord];
    
    [self showPDFFile];
    
    if ([self.mode isEqualToString:@"print"]) {
        NSLog(@"called print");
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
    
    NSString *filename = [NSString stringWithFormat:@"%@.pdf", currentEstimate.uniqueEstimateNo];
    
    [LACFileHandler saveFileInDocumentsDirectory:filename subFolderName:@"Uploads" withData:myData];
    
    sleep(2);
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Completed";
    sleep(2);
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
    [picker setSubject:@"Document Attached"];
    
    // Set up recipients
    if ([aEstimate.customerEmail length] > 0) {
        NSArray *toRecipients = [NSArray arrayWithObject:aEstimate.customerEmail];
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
    [picker addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf",currentEstimate.uniqueEstimateNo]];
    
    
    NSString *defaultText = [prefs valueForKey:@"estimateBodyText"];
    if ([defaultText length] > 0) {
        NSString *emailBody = defaultText;
        [picker setMessageBody:emailBody isHTML:NO];
    }
    else
    {
        [picker setMessageBody:@"Please find attached your document" isHTML:NO];
    }
    
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
    NSString* fileName = [NSString stringWithFormat:@"%@.pdf", currentEstimate.uniqueEstimateNo];
    
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
