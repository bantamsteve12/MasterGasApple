//
//  PDFViewController.h
//  MasterGas
//
//  Created by Stephen Lalor on 03/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Certificate.h"
#import "SDSyncEngine.h"
#import "MBProgressHUD.h"

@interface PDFViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) Certificate *currentCertificate;
@property (nonatomic, strong) NSArray *applianceInspections;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) NSString *mode;

@property (retain, nonatomic) Certificate *aCertificate;


-(void)showPDFFile;
-(NSString*)getPDFFileName;
@end
