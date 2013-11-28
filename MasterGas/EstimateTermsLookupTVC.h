//
//  EstimateTermsLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 26/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstimateTerm.h"
#import "MBProgressHUD.h"


@class EstimateTermsLookupTVC;

@protocol EstimateTermsLookupTVCDelegate <NSObject>

- (void)theEstimateTermWasSelectedFromTheList:(EstimateTermsLookupTVC *)controller;
@end

@interface EstimateTermsLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *estimateTerms;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) EstimateTerm *selectedEstimateTerm;

- (IBAction)refreshButtonTouched:(id)sender;

@end
