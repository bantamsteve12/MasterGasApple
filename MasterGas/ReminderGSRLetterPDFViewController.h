//
//  ReminderGSRLetterPDFViewController.h
//  MasterGas
//
//  Created by Stephen Lalor on 20/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Certificate.h"
#import "MBProgressHUD.h"

@interface ReminderGSRLetterPDFViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) Certificate *currentCertificate;
@property (nonatomic, strong) NSArray *applianceInspections;
@property (nonatomic, strong) NSArray *companyRecords;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (strong, nonatomic) NSString *mode;
@property (retain, nonatomic) Certificate *aCertificate;


-(void)showPDFFile;
-(NSString*)getPDFFileName;
@end
