//
//  InvoiceTermsLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 05/03/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceTerm.h"
#import "MBProgressHUD.h"

@class InvoiceTermsLookupTVC;

@protocol InvoiceTermsLookupTVCDelegate <NSObject>

- (void)theInvoiceTermWasSelectedFromTheList:(InvoiceTermsLookupTVC *)controller;
@end

@interface InvoiceTermsLookupTVC : UITableViewController <MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *invoiceTerms;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) InvoiceTerm *selectedInvoiceTerm;

- (IBAction)refreshButtonTouched:(id)sender;

@end
