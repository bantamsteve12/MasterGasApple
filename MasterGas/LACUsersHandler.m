//
//  LACUsersHandler.m
//  MasterGas
//
//  Created by Stephen Lalor on 21/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "LACUsersHandler.h"
#import "NSString+Additions.h"

@implementation LACUsersHandler


+ (NSString *) getCurrentEngineerId
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user = [prefs valueForKey:@"engineerId"];
    return [NSString checkForNilString:user];
}


+ (NSString *) getCurrentCompanyId
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *user = [prefs valueForKey:@"companyId"];
    return [NSString checkForNilString:user];
}


+ (void) storeUserInNSDefaults:(NSString *)engineerId withCompanyId:(NSString *)companyId
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:engineerId forKey:@"engineerId"];
    [prefs setObject:companyId forKey:@"companyId"];
    [prefs synchronize];
}

@end
