//
//  JobSheetsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 04/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobSheetsTVC : UITableViewController


@property (nonatomic, strong) NSArray *jobSheets;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

// Grouping of table required objects
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;

@property (strong, nonatomic) NSString *customerId;
@property bool limited;

- (IBAction)refreshButtonTouched:(id)sender;

@end
