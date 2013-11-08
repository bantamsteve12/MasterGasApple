//
//  LoginTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 28/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTVC : UITableViewController


@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *companyRecords;
//@property (strong, nonatomic) void (^updateCompletionBlock)(void);


@end
