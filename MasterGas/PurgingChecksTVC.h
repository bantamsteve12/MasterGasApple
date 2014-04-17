//
//  PurgingChecksTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 15/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "NSString+Additions.h"

@interface PurgingChecksTVC : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) IBOutlet UISegmentedControl *pRiskAssessmentCarriedOutSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pWrittenProcedurePreparedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pPersonsInVicinityNotifiedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pNoSmokingSignsDisplayedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pAppropiateValvesLabelledSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pNitrogenGasCheckedVerifiedSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pFireExtinguishersAvailableSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pTwoWayRadiosAvailableSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pElectricalBondsFittedSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *pPurgeVolumeGasMeterTextField;
@property (strong, nonatomic) IBOutlet UITextField *pPurgeVolumePipeworkAndFittingsTextField;
@property (strong, nonatomic) IBOutlet UITextField *pTotalPurgeVolumeTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pGasDetectorIntrinsicallySafeSegmentControl;
@property (strong, nonatomic) IBOutlet UITextField *pPurgeFinalTestValueTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pPurgeFinalTestUnitSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *pPurgeResultSegmentControl;

@property (strong, nonatomic) NSString *entityName;


@end
