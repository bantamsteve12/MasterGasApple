#import <UIKit/UIKit.h>
#import "NSString+Additions.h"
#import "LocationLookupTVC.h"
#import "ApplianceTypeLookupTVC.h"
#import "ApplianceMakeLookupTVC.h"
#import "ModelLookupTVC.h"

@interface WarningNoticeDetailsTVC : UITableViewController <LocationLookupTVCDelegate, ApplianceTypeLookupTVCDelegate, ApplianceMakeLookupTVCDelegate, ModelLookupTVCDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UISegmentedControl *gasEscapeSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *warningLabelStatementSegmentControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *warningLabelAttachedSegmentControl;

@property (strong, nonatomic) IBOutlet UISegmentedControl *gasUserNotPresentSegementControl;

@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceMakeTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceModelTextField;
@property (strong, nonatomic) IBOutlet UITextField *applianceSerialNumberField;

@property (strong, nonatomic) IBOutlet UITextView *immediatelyDangeoursReasonTextView;
@property (strong, nonatomic) IBOutlet UITextView *atRiskReasonTextView;
@property (strong, nonatomic) IBOutlet UITextView *notToCurrentStandardsReasonTextView;


@property (strong, nonatomic) NSString *entityName;


@end
