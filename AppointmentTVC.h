//
//  AppointmentTVC.h
//  SignificantDates
//
//  Created by Stephen Lalor on 29/11/2012.
//
//

#import <UIKit/UIKit.h>
#import "Appointment.h"


@interface AppointmentTVC : UITableViewController

@property (nonatomic, strong) NSArray *appointments;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;


@property (strong, nonatomic) Appointment *selectedAppointment;

@property (strong, nonatomic) NSString *customerId;
@property bool limited;
@property (nonatomic) int selectedSegmentIndex;
@property (copy, nonatomic) void (^addAppointmentCompletionBlock)(void);

@property (strong, nonatomic) IBOutlet UISegmentedControl *viewSelectionSegment;

- (IBAction)refreshButtonTouched:(id)sender;

@end
