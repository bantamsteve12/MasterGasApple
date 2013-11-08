//
//  CustomerSignoffTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 09/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerSignoffTVC : UITableViewController

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UISegmentedControl *ecvSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gasTightnessSegementControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gasInstallationPipeworkControl;
@property (strong, nonatomic) IBOutlet UITextField *equipotentialBondingControl;

@property (strong, nonatomic) IBOutlet UILabel *nextInspectionDateLabel;


@property (strong, nonatomic) NSString *entityName;



@end
