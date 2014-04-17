//
//  ServiceLetterPDFViewController.h
//  MasterGas
//
//  Created by Stephen Lalor on 23/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MaintenanceServiceCheck.h"
#import "MaintenanceServiceRecord.h"
#import "MBProgressHUD.h"


@interface ServiceLetterPDFViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate, UIDocumentInteractionControllerDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) MaintenanceServiceRecord *currentMaintenanceServiceRecord;
@property (nonatomic, strong) MaintenanceServiceCheck *currentMaintenanceServiceCheck;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) NSArray *companyRecords;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) NSString *mode;

@property (retain, nonatomic) MaintenanceServiceRecord *aMaintenanceServiceRecord;
@property (retain, nonatomic) MaintenanceServiceCheck *aMaintenanceServiceCheck;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

-(void)showPDFFile;
-(NSString*)getPDFFileName;
@end
