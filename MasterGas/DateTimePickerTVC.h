//
//  DateTimePickerTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 05/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateTimePickerTVC;

@protocol DatePickerTVCDelegate <NSObject>
- (void)theCancelButtonWasPressedOnTheDatePicker:(DateTimePickerTVC *)controller;
- (void)theDoneButtonWasPressedOnTheDatePicker:(DateTimePickerTVC *)controller;
@end

@interface DateTimePickerTVC : UITableViewController

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSDate *inputDate;
@property (nonatomic, strong) NSNumber *tag;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end




