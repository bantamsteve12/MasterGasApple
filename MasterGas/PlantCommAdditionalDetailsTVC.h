//
//  PlantCommAdditionalDetailsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 25/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "NSString+Additions.h"

@interface PlantCommAdditionalDetailsTVC : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UITextField *ventilationNaturalLowLevelTextField;
@property (strong, nonatomic) IBOutlet UITextField *ventilationNaturalHighLevelTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ventilationNaturalClearSegmentControl;

@property (strong, nonatomic) IBOutlet UITextField *ventilationMechanicalInletTextField;
@property (strong, nonatomic) IBOutlet UITextField *ventilationMechanicalExtractTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ventilationMechanicalInterlockSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *ventilationMechanicalClearSegmentControl;


@property (strong, nonatomic) IBOutlet UITextView *workCarriedOutTextView;
@property (strong, nonatomic) IBOutlet UITextView *remedialWorkRequiredTextView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *warningLabelNoticeIssuedSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *warningNoticeNumberTextField;

@property (strong, nonatomic) IBOutlet UISegmentedControl *responsiblePersonNotifiedWarningNoticeSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *responsiblePersonTextField;


@property (strong, nonatomic) NSString *entityName;


@end
