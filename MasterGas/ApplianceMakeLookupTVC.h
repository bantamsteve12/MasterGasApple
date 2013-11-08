//
//  ApplianceMakeLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 10/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplianceMake.h"
#import "MBProgressHUD.h"

@class ApplianceMakeLookupTVC;

@protocol ApplianceMakeLookupTVCDelegate <NSObject>

- (void)theApplianceMakeWasSelectedFromTheList:(ApplianceMakeLookupTVC *)controller;
@end


@interface ApplianceMakeLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *applianceMakes;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) ApplianceMake *selectedApplianceMake;

- (IBAction)refreshButtonTouched:(id)sender;

@end
