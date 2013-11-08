//
//  JobsheetPDFViewController.h
//  MasterGas
//
//  Created by Stephen Lalor on 05/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Jobsheet.h"
#import "SDSyncEngine.h"
#import "MBProgressHUD.h"
#import "LACUsersHandler.h"


@interface JobsheetPDFViewController : UIViewController<MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) Jobsheet *currentJobsheet;
@property (nonatomic, strong) NSArray *maintenanceServiceItems;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) NSString *mode;
@property (retain, nonatomic) Jobsheet *aJobsheet;

-(void)showPDFFile;
-(NSString*)getPDFFileName;
@end


