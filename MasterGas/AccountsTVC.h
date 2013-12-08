//
//  AccountsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 21/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceDetailTVC.h"
#import "EstimateDetailTVC.h"
#import "InvoicesTVC.h"

@interface AccountsTVC : UITableViewController

@property (nonatomic, strong) NSArray *invoices;
@property (nonatomic, strong) NSArray *estimates;


@end
