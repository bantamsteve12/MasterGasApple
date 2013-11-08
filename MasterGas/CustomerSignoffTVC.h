//
//  CustomerSignoffTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 01/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LACFileHandler.h"
#import "Signature.h"
#import "CustomerPositionLookupTVC.h"
#import "NSString+Additions.h"

@interface CustomerSignoffTVC : UITableViewController <SignatureDelegate, CustomerPositionLookupDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UITextField *customerSignOffNameTextField;
@property (strong, nonatomic) IBOutlet UILabel *customerSignoffDateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *signatureImageView;
@property (strong, nonatomic) IBOutlet UITextField *customerPositionTextField;


//@property (strong, nonatomic) IBOutlet PFImageView *pfIMageView;

@property (strong, nonatomic) NSString *certificateReferenceNumber;

// TODO signature.

@property (nonatomic, strong) NSArray *companyRecords;
@property (strong, nonatomic) NSString *entityName;

@end
