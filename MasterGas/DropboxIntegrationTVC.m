//
//  DropboxIntegrationTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 18/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "DropboxIntegrationTVC.h"


@interface DropboxIntegrationTVC ()

@end

@implementation DropboxIntegrationTVC


@synthesize displayNameLabel;
@synthesize emailLabel;
@synthesize dropboxLinkButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self setViewValues];
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self setViewValues];
}

-(void)setViewValues
{
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
 
    if (account.linked) {
        [dropboxLinkButton setTitle:@" Unlink from Dropbox" forState:UIControlStateNormal];
    }
    else
    {
        [dropboxLinkButton setTitle:@" Link to Dropbox" forState:UIControlStateNormal];
    }
    
    if (account.info.displayName.length > 0) {
        self.displayNameLabel.text = account.info.displayName;
        self.emailLabel.text = account.info.userName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)linkToDropboxButtonPressed:(id)sender
{
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
    if (account.linked) {
        [account unlink];
    }
    else
    {
        [[DBAccountManager sharedManager] linkFromController:self];
    }
  
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
