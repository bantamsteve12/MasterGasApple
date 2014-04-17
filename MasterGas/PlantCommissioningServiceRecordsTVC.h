//
//  PlantCommissioningServiceRecordsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 20/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlantCommissioningServiceRecordsTVC : UITableViewController

@property (nonatomic, strong) NSArray *certificates;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

//@property (strong, nonatomic) NSString *certificateType;

// Grouping of table required objects
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;

@property (nonatomic, strong) NSString *customerId;

- (IBAction)refreshButtonTouched:(id)sender;

@end
