//
//  LookupSettingsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 04/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookupSettingsItemTVC.h"

@interface LookupSettingsTVC : UITableViewController

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *footerDescription;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property bool itemIdRequired;

- (IBAction)refreshButtonTouched:(id)sender;

@end
