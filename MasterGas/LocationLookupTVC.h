//
//  LocationLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 10/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "MBProgressHUD.h"


@class LocationLookupTVC;

@protocol LocationLookupTVCDelegate <NSObject>

- (void)theLocationWasSelectedFromTheList:(LocationLookupTVC *)controller;
@end


@interface LocationLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}




@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) Location *selectedLocation;

- (IBAction)refreshButtonTouched:(id)sender;

@end
