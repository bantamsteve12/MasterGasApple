//
//  ReminderSelectionTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 17/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderCritieriaLookupTVC.h"
#import "ReminderResultsTVC.h"

@interface ReminderSelectionTVC : UITableViewController <ReminderCritieriaLookupTVCDelegate>


@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@property (strong, nonatomic) void (^updateCompletionBlock)(void);


@end
