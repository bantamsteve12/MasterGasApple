//
//  SDAppDelegate.h
//  SignificantDates
//
//  Created by Chris Wagner on 5/14/12.
//

#import <UIKit/UIKit.h>
#import "SDCoreDataController.h"
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong, readonly) SDCoreDataController *coreDataHelper;
- (SDCoreDataController*)cdh;

@end
