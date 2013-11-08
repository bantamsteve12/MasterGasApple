//
//  ReminderCritieriaLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 17/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplianceMake.h"
#import "MBProgressHUD.h"

@class ReminderCritieriaLookupTVC;

@protocol ReminderCritieriaLookupTVCDelegate <NSObject>

- (void)theOptionWasSelectedFromTheList:(ReminderCritieriaLookupTVC *)controller;
@end

@interface ReminderCritieriaLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *arrayItems;
@property (nonatomic, strong) NSString *selectedEntity;
@property (nonatomic, strong) NSString *selectedOption;

- (IBAction)refreshButtonTouched:(id)sender;

@end
