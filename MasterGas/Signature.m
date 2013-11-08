//
//  Signature.m
//  MasterGas
//
//  Created by Stephen Lalor on 17/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "Signature.h"

@interface Signature ()

@end

@implementation Signature

@synthesize delegate;
@synthesize signatureImageView;
@synthesize signatureImage;
@synthesize imageName;


- (IBAction)acceptSignature:(id)sender
{
    NSLog(@"acceptSignature");
    self.signatureImage = self.signatureImageView.image;
    [self.delegate theAcceptButtonWasPressedOnTheSignature:self];
}

- (IBAction)clear:(id)sender
{
    NSLog(@"clear");
    signatureImageView.image = nil;
}

-(IBAction)cancel:(id)sender
{
    [self.delegate theCancelButtonWasPressedOnTheSignature:self];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    signatureImageView.image = signatureImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
