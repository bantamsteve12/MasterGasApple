//
//  CallTypeTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 06/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallType.h"


@class CallTypeTVC;

@protocol CallTypeTVCDelegate <NSObject>

- (void)theCallTypeWasSelectedFromTheList:(CallTypeTVC *)controller;
@end



@interface CallTypeTVC : UITableViewController

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *callTypes;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) CallType *selectedCallType;

- (IBAction)refreshButtonTouched:(id)sender;

@end
