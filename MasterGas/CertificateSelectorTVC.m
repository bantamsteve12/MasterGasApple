//
//  CertificateSelectorTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 11/03/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "CertificateSelectorTVC.h"
#import "CertificatesTVC.h"
#import "BreakdownServiceRecordsTVC.h"
#import "GasMaintenanceRecordsTVC.h"
#import "WarningNoticesTVC.h"
#import "JobSheetsTVC.h"

@interface CertificateSelectorTVC ()

@end

@implementation CertificateSelectorTVC

@synthesize customerId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"DomesticGasRecordSegue"]) {
        CertificatesTVC *certificatesTVC = segue.destinationViewController;
        certificatesTVC.certificateType = @"Landlord Gas Safety Record";
        certificatesTVC.customerId = self.customerId;
    }
    else if ([segue.identifier isEqualToString:@"LPGCertificatesSegue"]) {
        CertificatesTVC *certificatesTVC = segue.destinationViewController;
        certificatesTVC.certificateType = @"LPG Gas Safety Record";
        certificatesTVC.customerId = self.customerId;
    }
    else if ([segue.identifier isEqualToString:@"GasBreakdownServiceSegue"]) {
        NSLog(@"GasBreakdownServiceSegue");
        BreakdownServiceRecordsTVC *breakdownServiceRecordsTVC = segue.destinationViewController;
        breakdownServiceRecordsTVC.recordType = @"Gas Breakdown Service Record";
        breakdownServiceRecordsTVC.customerId = self.customerId;
    }
    else if ([segue.identifier isEqualToString:@"GasMaintenanceRecordSegue"]) {
        NSLog(@"GasMaintenanceRecordSegue");
        GasMaintenanceRecordsTVC *gasMaintenanceRecordsTVC = segue.destinationViewController;
        gasMaintenanceRecordsTVC.recordType = @"Gas Service Maintenance Checklist";
        gasMaintenanceRecordsTVC.customerId = self.customerId;
    }

    else if ([segue.identifier isEqualToString:@"WarningNoticesSegue"]) {
        NSLog(@"WarningNoticesSegue");
        WarningNoticesTVC *warningNoticesTVC = segue.destinationViewController;
        warningNoticesTVC.recordType = @"Warning Notices";
        warningNoticesTVC.customerId = self.customerId;
    }
    else if ([segue.identifier isEqualToString:@"JobsheetsSegue"]) {
        NSLog(@"Jobsheets");
        JobSheetsTVC *jobsheetsTVC = segue.destinationViewController;
    //    jobsheetsTVC.recordType = @"Warning Notices";
        jobsheetsTVC.customerId = self.customerId;
    }

}


@end