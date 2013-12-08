//
//  SelectEstimateTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 06/12/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainWithThreeSubtitlesCell.h"
#import "Estimate.h"

@class SelectEstimateTVC;

@protocol SelectEstimateTVCDelegate <NSObject>

- (void)theEstimateWasSelectedFromTheList:(SelectEstimateTVC *)controller;
@end


@interface SelectEstimateTVC : UITableViewController


@property (nonatomic, strong) NSArray *estimates;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) Estimate *selectedEstimate;




@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)refreshButtonTouched:(id)sender;


@end



