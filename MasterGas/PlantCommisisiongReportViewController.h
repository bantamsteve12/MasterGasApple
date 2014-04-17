//
//  PlantCommisisiongReportViewController.h
//  MasterGas
//
//  Created by Stephen Lalor on 24/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "PlantCommissioningService.h"
#import "MBProgressHUD.h"


@interface PlantCommisisiongReportViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate, UIDocumentInteractionControllerDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) PlantCommissioningService *currentCertificate;
@property (nonatomic, strong) NSArray *applianceInspections;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (strong, nonatomic) NSString *mode;
@property (retain, nonatomic) PlantCommissioningService *aCertificate;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

-(void)showPDFFile;
-(NSString*)getPDFFileName;
@end
