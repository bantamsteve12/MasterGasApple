//
//  LACHelperMethods.h
//  MasterGas
//
//  Created by Stephen Lalor on 21/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "Reachability.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface LACHelperMethods : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


+ (void)showBasicOKAlertMessage:(NSString *)title withMessage:(NSString *)message;
+ (NSString *)YesNoNASegementControlValue:(int)selectedIndex;
+ (int)YesNoNASegementControlSelectedIndexForValue:(NSString *)value;

+ (NSString *)PassFailNASegementControlValue:(int)selectedIndex;
+ (int)PassFailNASegementControlSelectedIndexForValue:(NSString *)value;

+ (NSString *)TrueFalseNASegementControlValue:(int)selectedIndex;
+ (int)TrueFalseNASegementControlSelectedIndexForValue:(NSString *)value;

+(void)setCompanyStandardVatRate:(NSString *)standardVat;
+(NSString *)getCompanyStandardVatRate;

// generates md5 hash from string
+(NSString *) returnMD5Hash:(NSString*)concat;

//+(void)setFullUser:(NSString *)expiry;
+(bool)fullUser;

+(void)checkUserSubscriptionInCloud;
+(NSDictionary *) loginServiceCall;
+(NSString *)stringWithUrl:(NSURL *)url;
+(id) objectWithUrl:(NSURL *)url;

+(void)setUserPreferencesInNSDefaults:(NSManagedObjectContext *)mo;

+(void)setEmailPreferencesInNSDefaults:(NSManagedObjectContext *)mo;

+(NSString *)getDefaultCurrency;

+(NSString *)getCompanyName;

@end

