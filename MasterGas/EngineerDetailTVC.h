//
//  EngineerDetailTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 21/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Signature.h"

@interface EngineerDetailTVC : UITableViewController <SignatureDelegate>


@property (strong, nonatomic) NSManagedObjectID *managedObjectId;

@property (strong, nonatomic) IBOutlet UITextField *engineerNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *engineerGSRIDNumberTextField;
@property (strong, nonatomic) IBOutlet UISwitch *engineerActive;


@property (strong, nonatomic) IBOutlet UIImageView *signatureView;

@property (strong, nonatomic) NSString *entityName;

@property (strong, nonatomic) void (^updateCompletionBlock)(void);


@end

