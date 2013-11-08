//
//  Signature.h
//  MasterGas
//
//  Created by Stephen Lalor on 17/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"

@class Signature;

@protocol SignatureDelegate <NSObject>
- (void)theCancelButtonWasPressedOnTheSignature:(Signature *)controller;
- (void)theAcceptButtonWasPressedOnTheSignature:(Signature *)controller;
@end

@interface Signature : UIViewController


@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UIImageView *signatureImageView;
@property (strong, nonatomic) UIImage *signatureImage;
@property (strong, nonatomic) NSString *imageName;

@end
