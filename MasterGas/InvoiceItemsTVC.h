//
//  InvoiceItemsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 18/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceStockItemDetailTVC.h"
#import "StockItem.h"

@interface InvoiceItemsTVC : UITableViewController

@property (nonatomic, strong) NSArray *invoiceItems;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (nonatomic, strong) StockItem *selectedInvoiceStockItem;

@property (nonatomic, retain) NSMutableDictionary *sections;

- (IBAction)refreshButtonTouched:(id)sender;


@end


