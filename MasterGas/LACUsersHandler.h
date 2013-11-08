//
//  LACUsersHandler.h
//  MasterGas
//
//  Created by Stephen Lalor on 21/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface LACUsersHandler : NSObject

+ (NSString *) getCurrentEngineerId;
+ (NSString *) getCurrentCompanyId;
+ (void) storeUserInNSDefaults:(NSString *)engineerId withCompanyId:(NSString *)companyId;

@end
