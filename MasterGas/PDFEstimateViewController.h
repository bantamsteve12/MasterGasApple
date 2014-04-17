//
//  PDFEstimateViewController.h
//  MasterGas
//
//  Created by Stephen Lalor on 23/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Estimate.h"
#import "SDSyncEngine.h"
#import "MBProgressHUD.h"
#import "LACUsersHandler.h"



@interface PDFEstimateViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate, UIDocumentInteractionControllerDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) Estimate *currentEstimate;
@property (nonatomic, strong) NSArray *estimateItems;
@property (nonatomic, strong) NSArray *companyRecords;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) NSString *mode;
@property (retain, nonatomic) Estimate *aEstimate;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;


-(void)showPDFFile;
-(NSString*)getPDFFileName;
@end
