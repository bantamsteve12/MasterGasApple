//
//  CustomerLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 05/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"

@class CustomerLookupTVC;

@protocol CustomerLookupTVCDelegate <NSObject>

- (void)theCustomerWasSelectedFromTheList:(CustomerLookupTVC *)controller;
@end


@interface CustomerLookupTVC : UITableViewController

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSMutableArray *customers;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) Customer *selectedCustomer;
@property (nonatomic, retain) NSMutableDictionary *sections;


- (IBAction)refreshButtonTouched:(id)sender;

@end
