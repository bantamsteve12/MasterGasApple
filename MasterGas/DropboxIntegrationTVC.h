//
//  DropboxIntegrationTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 18/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>

@interface DropboxIntegrationTVC : UITableViewController 


@property (strong, nonatomic) IBOutlet UISwitch *dropboxAccessEnabled;
@property (strong, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;

@property (strong, nonatomic) IBOutlet UIButton *dropboxLinkButton;

@end

