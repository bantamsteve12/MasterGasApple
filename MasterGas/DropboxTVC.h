//
//  DropboxTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 30/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SDCoreDataController.h"
//#import "CoreDataHelper.h"
#import "DropboxHelper.h"

@interface DropboxTVC : UITableViewController <UIAlertViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) NSMutableArray *contents;
@property (assign, nonatomic) BOOL loading;
@property (strong, nonatomic) UIActionSheet *options;
@property (strong, nonatomic) UIAlertView *confirmRestore;
@property (strong, nonatomic) NSString *selectedZipFileName;
@end
