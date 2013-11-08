//
//  NSString+Additions.m
//  MasterGas
//
//  Created by Stephen Lalor on 30/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Additions)


+(NSString *)generateUniqueIdentifier
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge NSString *)uuidStringRef;
}

+(NSString *)generateUniqueNumberIdentifier{
    NSTimeInterval timeInMiliseconds = ([[NSDate date] timeIntervalSince1970] * 1000);
    NSString *millisecondsSince1970 = [NSString stringWithFormat:@"%f", timeInMiliseconds];
    NSArray *items = [millisecondsSince1970 componentsSeparatedByString:@"."];
    NSString *uniqueNumber = items[0];
    
    NSMutableString *str = [uniqueNumber mutableCopy];
    [str insertString:@"-" atIndex:4];
    [str insertString:@"-" atIndex:9];
    return str;
}

- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

//
+ (NSString *)checkForNilString:(NSString *) string {
   
    NSLog(@"checkForNilString called");
    
    if ((NSNull *) string == [NSNull null]) {
        return @"";
    }
    if (string == nil) {
        return @"";
    } else if ([string length] == 0) {
        return @"";
    } else {
        return string;
    } 
}

+ (BOOL ) stringIsEmpty:(NSString *) aString {
    
    if ((NSNull *) aString == [NSNull null]) {
        return YES;
    }
    
    if (aString == nil) {
        return YES;
    } else if ([aString length] == 0) {
        return YES;
    } else {
        aString = [aString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([aString length] == 0) {
            return YES;
        }
    }
    
    return NO;
}



-(BOOL)isBlank {
    if([[self stringByStrippingWhitespace] isEqualToString:@""])
        return YES;
    return NO;
}

-(BOOL)contains:(NSString *)string {
    NSRange range = [self rangeOfString:string];
    return (range.location != NSNotFound);
}

-(NSString *)stringByStrippingWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSArray *)splitOnChar:(char)ch {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    int start = 0;
    for(int i=0; i<[self length]; i++) {
        
        BOOL isAtSplitChar = [self characterAtIndex:i] == ch;
        BOOL isAtEnd = i == [self length] - 1;
        
        if(isAtSplitChar || isAtEnd) {
            //take the substring &amp; add it to the array
            NSRange range;
            range.location = start;
            range.length = i - start + 1;
            
            if(isAtSplitChar)
                range.length -= 1;
            
            [results addObject:[self substringWithRange:range]];
            start = i + 1;
        }
        
        //handle the case where the last character was the split char.  we need an empty trailing element in the array.
        if(isAtEnd && isAtSplitChar)
            [results addObject:@""];
    }
    
    return results;
}

-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to {
    NSString *rightPart = [self substringFromIndex:from];
    return [rightPart substringToIndex:to-from];
}

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}



@end
