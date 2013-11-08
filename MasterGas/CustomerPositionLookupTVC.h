//
//  CustomerPositionLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 15/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerPosition.h"
#import "MBProgressHUD.h"



@class CustomerPositionLookupTVC;

@protocol CustomerPositionLookupDelegate <NSObject>

- (void)theCustomerPositionWasSelectedFromTheList:(CustomerPositionLookupTVC *)controller;
@end


@interface CustomerPositionLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *customerPositions;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) CustomerPosition *selectedCustomerPosition;

- (IBAction)refreshButtonTouched:(id)sender;

@end
