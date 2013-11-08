//
//  InvoicesTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 08/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainWithThreeSubtitlesCell.h"


@interface InvoicesTVC : UITableViewController

@property (nonatomic, strong) NSArray *invoices;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *customerId;
@property bool limited;
@property bool outstanding;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
- (IBAction)refreshButtonTouched:(id)sender;

@end
