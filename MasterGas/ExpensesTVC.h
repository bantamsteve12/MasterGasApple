//
//  ExpensesTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 25/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainWithThreeSubtitlesCell.h"

@interface ExpensesTVC : UITableViewController

@property (nonatomic, strong) NSArray *expenses;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)refreshButtonTouched:(id)sender;

@end
