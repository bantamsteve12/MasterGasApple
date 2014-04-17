//
//  NonDomesticGasSafetyRecordViewController.h
//  MasterGas
//
//  Created by Stephen Lalor on 21/02/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "GasSafetyNonDomestic.h"
//#import "SDSyncEngine.h"
#import "MBProgressHUD.h"


@interface NonDomesticGasSafetyRecordViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate, UIDocumentInteractionControllerDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) GasSafetyNonDomestic *currentCertificate;
@property (nonatomic, strong) NSArray *applianceInspections;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) NSString *mode;

@property (retain, nonatomic) GasSafetyNonDomestic *aCertificate;

@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

-(void)showPDFFile;
-(NSString*)getPDFFileName;
@end
