/* NOTE: this is a work around to prevent the need to have the Facebook ios SDK in the app, which would bloat the file size.  Parse require this now.
 
 This method allows the app to build, but be careful not to use any facebook items in Parse */

NSString *FBTokenInformationExpirationDateKey = @"";
NSString *FBTokenInformationTokenKey = @"";
NSString *FBTokenInformationUserFBIDKey = @"";
@interface FBAppCall:NSObject
@end
@implementation FBAppCall
@end
@interface FBRequest:NSObject
@end
@implementation FBRequest
@end
@interface FBSession:NSObject
@end
@implementation FBSession
@end
@interface FBSessionTokenCaching:NSObject
@end
@implementation FBSessionTokenCaching
@end
@interface FBSessionTokenCachingStrategy:NSObject
@end
@implementation FBSessionTokenCachingStrategy
@end