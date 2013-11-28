//
//  PDFInvoiceViewController.h
//  MasterGas
//
//  Created by Stephen Lalor on 26/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Invoice.h"
#import "SDSyncEngine.h"
#import "MBProgressHUD.h"
#import "LACUsersHandler.h"


@interface PDFInvoiceViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) Invoice *currentInvoice;
@property (nonatomic, strong) NSArray *invoiceItems;
@property (nonatomic, strong) NSArray *companyRecords;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) NSString *mode;

@property (retain, nonatomic) Invoice *aInvoice;


-(void)showPDFFile;
-(NSString*)getPDFFileName;
@end
