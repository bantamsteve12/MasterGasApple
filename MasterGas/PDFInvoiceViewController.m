//
//  PDFInvoiceViewController.m
//  MasterGas
//
//  Created by Stephen Lalor on 26/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "PDFInvoiceViewController.h"
#import "CoreText/CoreText.h"
#import "PDFInvoiceRenderer.h"
#import "Company.h"
#import "SDCoreDataController.h"


@interface PDFInvoiceViewController ()

@end

@implementation PDFInvoiceViewController

@synthesize webView;
@synthesize currentInvoice;
@synthesize invoiceItems;
@synthesize companyRecords;
@synthesize managedObjectContext;
@synthesize managedObject;

@synthesize mode;
@synthesize aInvoice;
@synthesize documentInteractionController;

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        //   [self.managedObjectContext reset];
        
        self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
        
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"InvoiceItem"];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"invoiceUniqueNo" ascending:YES]]];
        
        [request setPredicate:[NSPredicate predicateWithFormat:@"(invoiceUniqueNo == %@)", self.currentInvoice.uniqueInvoiceNo]];
        

        self.invoiceItems = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        NSLog(@"1. invoice items = %i", self.invoiceItems.count);
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
    aInvoice = currentInvoice;
    invoiceItems = [[NSMutableArray alloc] init];
    
    [self loadRecordsFromCoreData];
    [self loadCompanyRecordFromCoreData];
    
    
    NSString* fileName = [self getPDFFileName];
    
    NSMutableArray *invoiceItemsMutableArray = [NSMutableArray arrayWithArray:invoiceItems];
    
    Company *companyRecord = [self.companyRecords objectAtIndex:0];

    [PDFInvoiceRenderer drawPDF:fileName withInvoice:aInvoice withInvoiceItems:invoiceItemsMutableArray withCompanyRecord:companyRecord];
    
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
                                  otherButtonTitles:@"Email", @"Print", @"Send to Dropbox", @"Open in..."
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
    
    if (buttonIndex == 3) {
        
        NSURL *URL = [NSURL fileURLWithPath:[self getPDFFileName]];
        
        if (URL) {
            // Initialize Document Interaction Controller
            self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
            
            // Configure Document Interaction Controller
            [self.documentInteractionController setDelegate:self];
            
            // Present Open In Menu
            [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        }
    }
    
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
	return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
	return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
	return self.view.frame;
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
    
    NSString *filename = [NSString stringWithFormat:@"%@.pdf", currentInvoice.uniqueInvoiceNo];
    
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
    if ([MFMailComposeViewController canSendMail]) {
        
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Invoice Attached"];
    
    // Set up recipients
    if ([aInvoice.customerEmail length] > 0) {
        NSArray *toRecipients = [NSArray arrayWithObject:aInvoice.customerEmail];
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
    [picker addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@.pdf",currentInvoice.uniqueInvoiceNo]];
    
    
    NSString *defaultInvoiceText = [prefs valueForKey:@"invoiceBodyText"];
    if ([defaultInvoiceText length] > 0) {
        NSString *emailBody = defaultInvoiceText;
        [picker setMessageBody:emailBody isHTML:NO];
    }
    else
    {
        [picker setMessageBody:@"Please find attached your invoice." isHTML:NO];
    }
    
    [self presentModalViewController:picker animated:YES];
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Email not setup"
                              message:@"You haven't setup emails on your device. Please setup you emails in the mail app for your device and try again."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        [alert show];
        
    }
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
    NSString* fileName = [NSString stringWithFormat:@"%@.pdf", currentInvoice.uniqueInvoiceNo];
    
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
