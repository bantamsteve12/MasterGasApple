//
//  SetupStepThreeTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 10/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Signature.h"

@interface SetupStepThreeTVC : UITableViewController <SignatureDelegate>


@property (strong, nonatomic) NSManagedObjectID *managedObjectId;

@property (strong, nonatomic) IBOutlet UITextField *engineerNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *engineerGSRIDNumberTextField;
@property (strong, nonatomic) IBOutlet UISwitch *engineerActive;
@property (strong, nonatomic) IBOutlet UIImageView *signatureView;

@property (strong, nonatomic) NSString *entityName;

- (IBAction)saveButtonTouched:(id)sender;

@end

