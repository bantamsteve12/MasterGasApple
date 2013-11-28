//
//  EstimatesTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 13/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainWithThreeSubtitlesCell.h"

@interface EstimatesTVC : UITableViewController

@property (nonatomic, strong) NSArray *estimates;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *customerId;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)refreshButtonTouched:(id)sender;


@end



