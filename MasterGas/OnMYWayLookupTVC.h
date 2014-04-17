#import <UIKit/UIKit.h>
#import "OnMyWay.h"


@class OnMYWayLookupTVC;

@protocol OnMYWayLookupTVCDelegate <NSObject>

- (void)theOnMyWayLookupWasSelectedFromTheList:(OnMYWayLookupTVC *)controller;
@end


@interface OnMYWayLookupTVC : UITableViewController


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *onMyWayItems;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) OnMyWay *selectedOnMyWayItem;

@end