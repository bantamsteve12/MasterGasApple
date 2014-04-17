//
//  PDFPaymentViewController.h
//  MasterGas
//
//  Created by Stephen Lalor on 17/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Payment.h"
#import "SDSyncEngine.h"
#import "MBProgressHUD.h"
#import "LACUsersHandler.h"
#import "Invoice.h"

@interface PDFPaymentViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate, UIDocumentInteractionControllerDelegate> {
	MBProgressHUD *HUD;
}

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) Payment *currentPayment;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) NSString *mode;
@property (retain, nonatomic) Payment *aPayment;
@property (strong, nonatomic) Invoice *invoice;

@property (nonatomic, strong) NSArray *companyRecords;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

-(void)showPDFFile;
-(NSString*)getPDFFileName;
@end


