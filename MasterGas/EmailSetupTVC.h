//
//  EmailSetupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 11/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailSetupTVC : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *ccEmailAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *bccEmailAddressTextField;
@property (strong, nonatomic) IBOutlet UITextView *certificateBodyTextTextViewField;
@property (strong, nonatomic) IBOutlet UITextView *invoiceBodyTextTextViewField;


@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *emailRecords;
@property (strong, nonatomic) void (^updateCompletionBlock)(void);


@end


