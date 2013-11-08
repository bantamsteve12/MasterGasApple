#import <UIKit/UIKit.h>
#import "LACHelperMethods.h"
#import "SBJson.h"
#import "LACUsersHandler.h"
#import "MBProgressHUD.h"


@interface MyAccountTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}



@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *subscriptionTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *subscriptionExpiryLabel;

@end
