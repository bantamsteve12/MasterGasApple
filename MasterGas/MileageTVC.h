//
//  MileageTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 05/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainWithTwoSubtitlesCell.h"

@interface MileageTVC : UITableViewController

@property (nonatomic, strong) NSArray *mileageRecords;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)refreshButtonTouched:(id)sender;

@end

