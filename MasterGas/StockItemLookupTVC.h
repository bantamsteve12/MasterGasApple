//
//  StockItemLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 08/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockItem.h"
#import "InvoiceStockItemDetailTVC.h"

@class StockItemLookupTVC;

@protocol StockItemLookupTVCDelegate <NSObject>

- (void)theStockItemWasSelectedFromTheList:(StockItemLookupTVC *)controller;
@end

@interface StockItemLookupTVC : UITableViewController

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *stockItems;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) StockItem *selectedStockItem;

@property (nonatomic, retain) NSMutableDictionary *sections;

- (IBAction)refreshButtonTouched:(id)sender;

@end
