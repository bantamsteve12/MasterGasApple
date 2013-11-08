//
//  EngineersTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 21/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EngineerDetailTVC.h"

@interface EngineersTVC : UITableViewController

@property (nonatomic, strong) NSArray *engineers;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)refreshButtonTouched:(id)sender;


@end


