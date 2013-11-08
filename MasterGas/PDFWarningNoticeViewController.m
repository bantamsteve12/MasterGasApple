//
//  PDFWarningNoticeViewController.m
//  MasterGas
//
//  Created by Stephen Lalor on 23/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "PDFWarningNoticeViewController.h"
#import "CoreText/CoreText.h"
#import "PDFWarningNoticeRenderer.h"


@interface PDFWarningNoticeViewController ()

@end

@implementation PDFWarningNoticeViewController

@synthesize webView;
@synthesize currentWarningNotice;
@synthesize warningNoticeItems;
@synthesize managedObjectContext;
@synthesize managedObject;

@synthesize mode;
@synthesize aWarningNotice;

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
	
    //[HUD show:YES];
    
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
    aWarningNotice = currentWarningNotice;

    NSString* fileName = [self getPDFFileName];
    
    // Could probably tidy up in a future release to use type def
    NSString *certificateReportLayoutName = @"GasWarningNotice";
    
    [PDFWarningNoticeRenderer drawPDF:fileName withWarningNotice:aWarningNotice withCertificateReportLayoutName:certificateReportLayoutName];
    
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
    
    NSString *filename = [NSString stringWithFormat:@"%@.pdf", currentWarningNotice.warningNoticeNumber];
    
    [LACFileHandler saveFileInDocumentsDirectory:filename subFolderName:@"Uploads" withData:myData];
    
    sleep(2);
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Completed";
    sleep(2);
}

-(void)print:(NSString *)filePath
{
    
    //   NSString *filename = [appDelegate.pdfFilePath lastPathComponent];
    //   filename = [filename stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
    
    //  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //  NSString *documentsDirectory = [paths objectAtIndex:0];
    // NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    
    //  BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
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
    [picker setSubject:@"Gas Warning Notice Attached"];
    
    // Set up recipients
    if ([aWarningNotice.customerEmail length] > 0) {
        NSArray *toRecipients = [NSArray arrayWithObject:aWarningNotice.customerEmail];
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
    [picker addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf",currentWarningNotice.warningNoticeNumber]];
    
    [picker setMessageBody:@"Please find attached your Gas Warning Notice." isHTML:NO];
    
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
    
    NSString* fileName = [NSString stringWithFormat:@"%@.pdf", currentWarningNotice.warningNoticeNumber];
    
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
