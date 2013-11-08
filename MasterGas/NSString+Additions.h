//
//  NSString+Additions.h
//  MasterGas
//
//  Created by Stephen Lalor on 30/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

+(NSString *)generateUniqueIdentifier;
+(NSString *)generateUniqueNumberIdentifier;
-(NSString *)MD5;
//-(NSString *)checkForNilString;

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

+ (NSString *)checkForNilString:(NSString *) string;

+ (BOOL ) stringIsEmpty:(NSString *) aString;
    

-(BOOL)isBlank;
-(BOOL)contains:(NSString *)string;
-(NSArray *)splitOnChar:(char)ch;
-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;
-(NSString *)stringByStrippingWhitespace;


@end
