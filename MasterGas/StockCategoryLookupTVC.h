//
//  StockCategoryLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 20/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockCategory.h"
#import "MBProgressHUD.h"

@class StockCategoryLookupTVC;

@protocol StockCategoryLookupTVCDelegate <NSObject>
- (void)theStockCategoryWasSelected:(StockCategoryLookupTVC *)controller;
@end


@interface StockCategoryLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *stockCategories;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) StockCategory *selectedStockCategory;

- (IBAction)refreshButtonTouched:(id)sender;

@end
