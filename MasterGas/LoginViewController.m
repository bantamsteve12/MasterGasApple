//
//  LoginViewController.m
//  MasterGas
//
//  Created by Stephen Lalor on 12/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface LoginViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation LoginViewController

@synthesize fieldsBackground;
@synthesize bgFieldImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBG.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]]];
    [self.logInView.logInButton setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal];
    [self.logInView.logInButton setImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateHighlighted];
    [self.logInView.logInButton setTitle:@"Log in" forState:UIControlStateNormal];
    [self.logInView.logInButton setTitle:@"Log in" forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"Register" forState:UIControlStateHighlighted];
    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
}

- (void)viewDidLayoutSubviews {
    
    [self layoutView];
  }


-(void)layoutView
{
    [self.bgFieldImage removeFromSuperview];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL inLandscape = UIDeviceOrientationIsLandscape(currentOrientation);
    
    if (inLandscape) {
        screenWidth = screenRect.size.height / 2;
        screenHeight = screenRect.size.width;
    }
    else
    {
        screenWidth = screenRect.size.width / 2;
        screenHeight = screenRect.size.height;
    }
    
    // Set frame for elements
    self.bgFieldImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginFieldBG.png"]];
    [self.bgFieldImage setFrame:CGRectMake(screenWidth-125, 105.0f, 250.0f, 90.0f)];
    [self.logInView addSubview:self.bgFieldImage];
    [self.logInView sendSubviewToBack:self.bgFieldImage];
    
    [self.logInView.usernameField setFrame:CGRectMake(screenWidth-125, 105.0f, 250.0f, 40.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(screenWidth-125, 150.0f, 250.0f, 40.0f)];
    [self.logInView.passwordForgottenButton setFrame:CGRectMake(screenWidth-145, 125.0f, 20.0f, 45.0f)];
    [self.logInView.logo setFrame:CGRectMake(screenWidth-93.5, 30.0f, 187.0f, 58.5f)];
    [self.logInView.logInButton setFrame:CGRectMake(screenWidth-125, 200.0f, 250.0f, 40.0f)];
    [self.logInView.signUpButton setFrame:CGRectMake(screenWidth-125, 245.0f, 250.0f, 40.0f)];
    [self.logInView.signUpLabel setFrame:CGRectMake(screenWidth-125, 275.0f, 250.0f, 40.0f)];

}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self layoutView];
}



@end
