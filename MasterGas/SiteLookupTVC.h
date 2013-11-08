//
//  SiteLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 31/10/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sites.h"

@class SiteLookupTVC;

@protocol SiteLookupTVCDelegate <NSObject>
- (void)theSiteWasSelectedFromTheList:(SiteLookupTVC *)controller;
@end


@interface SiteLookupTVC : UITableViewController

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSMutableArray *sites;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) Sites *selectedSite;
@property (nonatomic, retain) NSMutableDictionary *sections;

@property (nonatomic, strong) NSString *customerNo;

@end
