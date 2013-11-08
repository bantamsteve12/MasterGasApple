//
//  DateTimePickerTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 05/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "DateTimePickerTVC.h"

@interface DateTimePickerTVC ()

@end

@implementation DateTimePickerTVC

@synthesize delegate;
@synthesize dateLabel;
@synthesize datePicker;
@synthesize inputDate;
@synthesize navBar;
@synthesize tag;

- (void)viewWillAppear:(BOOL)animated
{
  
    //[tableView setContentOffset:tableView.contentOffset animated:NO];
    
    [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
    self.tableView.alwaysBounceVertical = NO;
    
    
    if(self.inputDate != nil)
    {
        //set Date formatter
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        if(self.datePicker.datePickerMode == UIDatePickerModeDate)
        {
            [formatter setDateFormat:@"d MMMM yyyy"];
        }
        else if(self.datePicker.datePickerMode == UIDatePickerModeTime)
        {
            [formatter setDateFormat:@"HH:mm"];
        }
        else
        {
            [formatter setDateFormat:@"d MMMM yyyy - HH:mm"];
        }
        NSString *date = [[NSString alloc] initWithFormat:@"%@", [formatter stringFromDate:self.inputDate]];
        dateLabel.text = date;
    }

    // Initialization code
    
    if(self.inputDate != nil)
    {
        datePicker.date = self.inputDate;
    }
    else
    {
        datePicker.date = [NSDate date];
        [self changeDateInLabel:nil];
	}
    
    [datePicker addTarget:self
                   action:@selector(changeDateInLabel:)
         forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:datePicker];
	
    [super viewWillAppear:animated];
}


- (void)changeDateInLabel:(id)sender{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
   
    if(self.datePicker.datePickerMode == UIDatePickerModeDate)
    {
        [df setDateFormat:@"d MMMM yyyy"];
    }
    else if(self.datePicker.datePickerMode == UIDatePickerModeTime)
    {
        [df setDateFormat:@"HH:mm"];
    }
    else
    {
        [df setDateFormat:@"d MMMM yyyy - HH:mm"];
    }
    
   
    dateLabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:datePicker.date]];
    
    self.inputDate = datePicker.date;
}


- (IBAction)save:(id)sender
{
   [self.delegate theDoneButtonWasPressedOnTheDatePicker:self];
   
}
- (IBAction)cancel:(id)sender
{
   [self.delegate theCancelButtonWasPressedOnTheDatePicker:self];
}

@end
