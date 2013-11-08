//
//  CustomerTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 02/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerTVC : UITableViewController

@property (nonatomic, strong) NSMutableArray *customers;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;


@property (nonatomic, retain) NSMutableDictionary *sections;


- (IBAction)refreshButtonTouched:(id)sender;

@end
