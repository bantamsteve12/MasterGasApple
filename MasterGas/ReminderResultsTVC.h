//
//  ReminderResultsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 17/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderResultsTVC : UITableViewController

@property (nonatomic, strong) NSArray *reminders;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) NSString *month;
@property (strong, nonatomic) NSString *year;

@end
