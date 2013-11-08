//
//  WarningNoticesTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 20/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarningNoticesTVC : UITableViewController


@property (nonatomic, strong) NSArray *records;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) NSString *recordType;

// Grouping of table required objects
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;

@property (nonatomic, strong) NSString *customerId;

- (IBAction)refreshButtonTouched:(id)sender;


@end

