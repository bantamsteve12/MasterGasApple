//
//  PasswordResetTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 27/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LACHelperMethods.h"
#import "SBJson.h"
#import "LACUsersHandler.h"
#import "MBProgressHUD.h"


@interface PasswordResetTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

@end
