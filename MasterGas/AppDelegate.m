#import <Parse/Parse.h>
#import <Dropbox/Dropbox.h>
#import "AppDelegate.h"
#import "SDSyncEngine.h"
#import "LACHelperMethods.h"

#import "Appointment.h"
#import "Customer.h"
#import "Certificate.h"
#import "CallType.h"
#import "Location.h"
#import "ApplianceType.h"
#import "ApplianceMake.h"
#import "ApplianceModel.h"
#import "ApplianceInspection.h"
#import "Company.h"
#import "Engineer.h"
#import "CustomerPosition.h"
#import "Expense.h"
#import "ExpenseItem.h"
#import "ExpenseItemType.h"
#import "ExpenseItemSupplier.h"
#import "ExpenseItemCategory.h"
#import "VehicleRegistration.h"
#import "Mileage.h"
#import "MileageItem.h"
#import "Invoice.h"
#import "InvoiceItem.h"
#import "StockCategory.h"
#import "StockItem.h"
#import "Image.h"
#import "InvoiceTerm.h"
#import "MaintenanceServiceRecord.h"
#import "WarningNotice.h"
#import "PaymentType.h"
#import "NSUserDefaults+MPSecureUserDefaults.h"
#import "LACHelperMethods.h"
#import "JobStatus.h"
#import "EstimateTerm.h"


@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Crashlytics startWithAPIKey:@"62e83c64d7d72a7cc73f1e42bd95f3c8ebf11606"];
        
    
    // The account manager stores all the account info. Create this when your app launches
    DBAccountManager* accountMgr =
    [[DBAccountManager alloc] initWithAppKey:@"arygwh7m2j01dk0" secret:@"qkjad5s094w994z"];
    [DBAccountManager setSharedManager:accountMgr];
  
    DBAccount *account = accountMgr.linkedAccount;
  
    if (account) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
    }

    
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[CallType class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Location class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[ApplianceType class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[ApplianceMake class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[CustomerPosition class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[ExpenseItemType class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[ExpenseItemSupplier class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[ExpenseItemCategory class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[StockCategory class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[InvoiceTerm class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[PaymentType class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[JobStatus class]];
    [[SDSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[EstimateTerm class]];
    
    
    [Parse setApplicationId:@"SXkkKl2uJPIvy7yAo86fJjkVsXaOf8ClEykLR1FY"
                  clientKey:@"tm4MNkHROLpfTfVTTeqikecooYvlruCLJ3i14oIT"];
    
      return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
    if (account) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
        NSLog(@"App linked successfully!");
        return YES;
    }
}


-(void)checkDefaults
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  //  [[SDSyncEngine sharedEngine] startSync];
  
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

/*
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[PaylevenAppApi sharedInstance] handleOpenUrl:url bundleId:sourceApplication];
    return YES;
}
*/
@end
