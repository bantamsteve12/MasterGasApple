//
//  EngineerSignoffTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 10/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerTVC.h"
#import "EngineerLookupTVC.h"
#import "NSString+Additions.h"

@interface EngineerSignoffTVC : UITableViewController <DatePickerTVCDelegate, EngineerLookupTVCDelegate>

//@property (strong, nonatomic) NSManagedObjectID *managedObjectId;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UITextField *engineerSignoffTradingTitleTextField;
@property (strong, nonatomic) IBOutlet UITextField *engineerSignoffAddressLine1TextField;
@property (strong, nonatomic) IBOutlet UITextField *engineerSignoffAddressLine2TextField;
@property (strong, nonatomic) IBOutlet UITextField *engineerSignoffAddressLine3TextField;
@property (strong, nonatomic) IBOutlet UITextField *engineerSignoffPostcodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *engineerSignoffTelNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *engineerSignoffMobileNumberTextField;
@property (strong, nonatomic) IBOutlet UITextField *engineerSignoffCompanyGasSafeRegNumberTextField;

@property (strong, nonatomic) IBOutlet UITextField *engineerSignoffEngineerNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *engineerSignoffEngineerIDCardRegNumberTextField;
@property (strong, nonatomic) IBOutlet UILabel *engineerSignoffDateLabel;

@property (nonatomic, strong) NSArray *companyRecords;
@property (strong, nonatomic) NSString *entityName;



@end
