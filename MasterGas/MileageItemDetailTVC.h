//
//  MileageItemDetailTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 05/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MileageItem.h"
#import "VehicleRegistrationLookupTVC.h"
#import "DateTimePickerTVC.h"


@interface MileageItemDetailTVC : UITableViewController <DatePickerTVCDelegate, VehicleRegistrationLookupTVCDelegate>

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) MileageItem *selectedMileageItem;
@property (strong, nonatomic) NSString *uniqueClaimNo;

@property (strong, nonatomic) NSString *entityName;

@property (strong, nonatomic) IBOutlet UITextField *journeyDescriptionTextField;
@property (strong, nonatomic) IBOutlet UITextField *startMileageTextField;
@property (strong, nonatomic) IBOutlet UITextField *finishMilageTextField;
@property (strong, nonatomic) IBOutlet UITextField *totalMilesTextField;
@property (strong, nonatomic) IBOutlet UITextField *journeyNotesTextField;
@property (strong, nonatomic) IBOutlet UITextField *vehicleRegistrationTextField;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (copy, nonatomic) void (^updateCompletionBlock)(void);



@end
