//
//  EngineerLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 27/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Engineer.h"
#import "MBProgressHUD.h"


@class EngineerLookupTVC;

@protocol EngineerLookupTVCDelegate <NSObject>
- (void)theEngineerWasSelectedFromTheList:(EngineerLookupTVC *)controller;
@end


@interface EngineerLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}



@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *engineers;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) Engineer *selectedEngineer;

- (IBAction)refreshButtonTouched:(id)sender;

@end
