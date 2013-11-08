//
//  SignupViewController.m
//  MasterGas
//
//  Created by Stephen Lalor on 12/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "SignupViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SignupViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation SignupViewController

//@synthesize fieldsBackground;
@synthesize bgFieldImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBG.png"]]];
   // [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
    [self.signUpView setLogo:Nil];
    
    // Change button apperance
    [self.signUpView.signUpButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"Sign up" forState:UIControlStateHighlighted];
   
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"Exit.png"] forState:UIControlStateNormal];
    
    
    // Add background for fields
    [self setFieldsBackground:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignUpFieldBG.png"]]];
    [self.signUpView insertSubview:bgFieldImage atIndex:1];
    
    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0f;
    layer = self.signUpView.additionalField.layer;
    layer.shadowOpacity = 0.0f;
    
    // Set text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.additionalField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    // Change "Additional" to match our use
    [self.signUpView.usernameField setPlaceholder:@"Username"];
    [self.signUpView.additionalField setPlaceholder:@"Company Name"];
    
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
    else {
        screenWidth = screenRect.size.width / 2;
        screenHeight = screenRect.size.height;
    }
    
    [self.signUpView.usernameField setFrame:CGRectMake(screenWidth-125, 15.0f, 250.0f, 40.0f)];
    [self.signUpView.passwordField setFrame:CGRectMake(screenWidth-125, 55.0f, 250.0f, 40.0f)];
    [self.signUpView.emailField setFrame:CGRectMake(screenWidth-125, 95.0f, 250.0f, 40.0f)];
    [self.signUpView.additionalField setFrame:CGRectMake(screenWidth-125, 135.0f, 250.0f, 40.0f)];
    
    // Set frame for elements
    self.bgFieldImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignUpFieldBG.png"]];
    [self.bgFieldImage setFrame:CGRectMake(screenWidth-125, 15.0f, 250.0f, 160.0f)];
    [self.signUpView addSubview:self.bgFieldImage];
    [self.signUpView sendSubviewToBack:self.bgFieldImage];

    [self.signUpView.signUpButton setFrame:CGRectMake(screenWidth-125, 180.0f, 250.0f, 40.0f)];
    [self.signUpView.dismissButton setFrame:CGRectMake(screenWidth-125, 225.0f, 250.0f, 40.0f)];
    
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
