//
//  GasWarningNoticesTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 19/04/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GasWarningNoticesTVC : UITableViewController
@property (nonatomic, strong) NSArray *warningNotices;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (strong, nonatomic) NSString *certificateType;

- (IBAction)refreshButtonTouched:(id)sender;

@end
