//
//  JobstatusLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 04/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobStatus.h"
#import "MBProgressHUD.h"

@class JobstatusLookupTVC;

@protocol JobstatusLookupTVCDelegate <NSObject>
- (void)theJobStatusWasSelected:(JobstatusLookupTVC *)controller;
@end


@interface JobstatusLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *jobStatuses;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) JobStatus *selectedJobStatus;

- (IBAction)refreshButtonTouched:(id)sender;

@end
