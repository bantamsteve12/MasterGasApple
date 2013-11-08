//
//  SendReminderTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 18/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Certificate.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "LACHelperMethods.h"

#import "MaintenanceServiceRecord.h"
#import "MaintenanceServiceCheck.h"

@interface SendReminderTVC : UITableViewController

@property (strong, nonatomic) Certificate *certicate;
@property (strong, nonatomic) MaintenanceServiceCheck *maintenanceServiceCheck;
@property (strong, nonatomic) MaintenanceServiceRecord *maintenanceServiceRecord;

@property (nonatomic, strong) NSArray *applianceItems;

-(IBAction)sendSMSReminderButtonPressed:(id)sender;
-(IBAction)sendEmailButtonPressed:(id)sender;

@end

