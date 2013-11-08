//
//  PaymentTypeLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 01/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentType.h"
#import "MBProgressHUD.h"


@class PaymentTypeLookupTVC;

@protocol PaymentTypeLookupTVCDelegate <NSObject>
- (void)thePaymentTypeWasSelected:(PaymentTypeLookupTVC *)controller;
@end

@interface PaymentTypeLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) PaymentType *selectedPaymentType;

- (IBAction)refreshButtonTouched:(id)sender;

@end
