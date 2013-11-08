//
//  MileageDetailTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 05/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "MBProgressHUD.h"
#import "EngineerLookupTVC.h"


@interface MileageDetailTVC : UITableViewController <EngineerLookupTVCDelegate, DatePickerTVCDelegate, MBProgressHUDDelegate> {
   	MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;

@property (strong, nonatomic) IBOutlet UITextField *uniqueClaimReferenceTextField;
@property (strong, nonatomic) IBOutlet UITextField *referenceTextField;
@property (strong, nonatomic) IBOutlet UILabel *mileageClaimDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *engineerNameLabel;

@property (strong, nonatomic) NSString *entityName;


@property (strong, nonatomic) void (^updateCompletionBlock)(void);




@end
