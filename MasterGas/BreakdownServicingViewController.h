//
//  BreakdownServicingViewController.h
//  MasterGas
//
//  Created by Stephen Lalor on 13/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MaintenanceServiceRecord.h"
#import "SDSyncEngine.h"
#import "MBProgressHUD.h"
#import "LACUsersHandler.h"


@interface BreakdownServicingViewController :UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) MaintenanceServiceRecord *currentMaintenanceServiceRecord;
@property (nonatomic, strong) NSArray *maintenanceServiceItems;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) NSString *mode;
@property (retain, nonatomic) MaintenanceServiceRecord *aMaintenanceServiceRecord;

-(void)showPDFFile;
-(NSString*)getPDFFileName;
@end


