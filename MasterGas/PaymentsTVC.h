//
//  PaymentsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 01/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainWithThreeSubtitlesCell.h"
#import "Invoice.h"


@interface PaymentsTVC : UITableViewController 

@property (nonatomic, strong) NSArray *payments;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *invoiceNo;
@property (nonatomic, strong) Invoice *invoice;
@property (nonatomic, strong) NSString *customerId;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

- (IBAction)refreshButtonTouched:(id)sender;
- (IBAction)payWithPaylevenPressed:(id)sender;

@end
