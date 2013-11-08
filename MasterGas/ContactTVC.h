//
//  ContactTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 06/10/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LACHelperMethods.h"
#import "SBJson.h"
#import "LACUsersHandler.h"
#import "MBProgressHUD.h"
#import "NSString+Additions.h"


@interface ContactTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}



@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *deviceTypeLabel;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *contactNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *subjectTextField;
@property (strong, nonatomic) IBOutlet UITextView *messageTextTextView;


@end
