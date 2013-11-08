//
//  BreakdownServiceFaultsActionsRemedialTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 16/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Additions.h"

@interface BreakdownServiceFaultsActionsRemedialTVC : UITableViewController


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UITextView *detailsOfFaultsTextView;
@property (strong, nonatomic) IBOutlet UITextView *remedialWorkTakenTextView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *warningNoticeIssuedSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *warningNoticeNumberTextField;

@property (strong, nonatomic) NSString *entityName;


@end
