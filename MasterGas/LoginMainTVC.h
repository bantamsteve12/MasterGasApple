//
//  LoginMainTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 24/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LACHelperMethods.h"
#import "SBJson.h"
#import "LACUsersHandler.h"

@interface LoginMainTVC : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end
