//
//  SitesTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 30/10/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SitesTVC : UITableViewController

@property (nonatomic, strong) NSMutableArray *sites;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;


@property (nonatomic, retain) NSMutableDictionary *sections;

@property (nonatomic, strong) NSString *customerNo;

- (IBAction)refreshButtonTouched:(id)sender;

@end
