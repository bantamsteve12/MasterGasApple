//
//  UIColor+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 03/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)
+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}
@end