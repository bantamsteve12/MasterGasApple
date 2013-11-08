//
//  ApplianceTypeLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 10/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplianceType.h"
#import "MBProgressHUD.h"

@class ApplianceTypeLookupTVC;

@protocol ApplianceTypeLookupTVCDelegate <NSObject>

- (void)theApplianceTypeWasSelectedFromTheList:(ApplianceTypeLookupTVC *)controller;
@end

@interface ApplianceTypeLookupTVC : UITableViewController  <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *applianceTypes;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) ApplianceType *selectedApplianceType;

- (IBAction)refreshButtonTouched:(id)sender;

@end
