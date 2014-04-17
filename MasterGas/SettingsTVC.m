//
//  SettingsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 20/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "SettingsTVC.h"
//#import "SDSyncEngine.h"
//#import "LoginViewController.h"
//#import "SignupViewController.h"
#import "LACUsersHandler.h"

@interface SettingsTVC ()

@end

@implementation SettingsTVC


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"CompanyDetailsSegue"]) {
        CompanyTVC *companyTVC = segue.destinationViewController;
   }
   else if ([segue.identifier isEqualToString:@"EmailSetupSegue"]) {
        CompanyTVC *companyTVC = segue.destinationViewController;
    }
   else if ([segue.identifier isEqualToString:@"ApplianceManufacturersSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"ApplianceMake";
       lookupSettingsTVC.titleName = @"Manufacturers";
       lookupSettingsTVC.footerDescription = @"Appliance Manufacturers used in certificates and records.";
   }
   else if ([segue.identifier isEqualToString:@"ApplianceModelsSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"ApplianceModel";
       lookupSettingsTVC.titleName = @"Models";
       lookupSettingsTVC.footerDescription = @"Appliance Models used in certificates and records.";
   }
   else if ([segue.identifier isEqualToString:@"ApplianceTypesSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"ApplianceType";
       lookupSettingsTVC.titleName = @"Appliance Types";
       lookupSettingsTVC.footerDescription = @"Appliance Types used in certificates and records.";
   }
   else if ([segue.identifier isEqualToString:@"CallTypesSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"CallType";
       lookupSettingsTVC.titleName = @"Call Types";
       lookupSettingsTVC.footerDescription = @"Call types used in the appointment diary.";
   }
   else if ([segue.identifier isEqualToString:@"ExpenseCategoriesSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"ExpenseItemCategory";
       lookupSettingsTVC.titleName = @"Expense Categories";
       lookupSettingsTVC.footerDescription = @"Expense categories used to associate an expense item with a category.";
   }
   else if ([segue.identifier isEqualToString:@"ExpenseTypesSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"ExpenseItemType";
       lookupSettingsTVC.titleName = @"Expense Types";
       lookupSettingsTVC.footerDescription = @"Expense type used to associate an expense item with a type.";
   }
   else if ([segue.identifier isEqualToString:@"ExpenseSuppliersSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"ExpenseItemSupplier";
       lookupSettingsTVC.titleName = @"Expense Suppliers";
       lookupSettingsTVC.footerDescription = @"Expense suppliers used to associate an expense item with a supplier of the item.";
       lookupSettingsTVC.itemIdRequired = YES;
   }
   else if ([segue.identifier isEqualToString:@"EstimateQuoteTermsSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"EstimateTerm";
       lookupSettingsTVC.titleName = @"Estimate / Quote Terms";
       lookupSettingsTVC.footerDescription = @"Terms for use with estimates and quotes.";
   }
   else if ([segue.identifier isEqualToString:@"JobStatusSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"JobStatus";
       lookupSettingsTVC.titleName = @"Job Statuses";
       lookupSettingsTVC.footerDescription = @"Job statuses for use with jobsheets";
   }
   else if ([segue.identifier isEqualToString:@"OnMyWaySegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"OnMyWay";
       lookupSettingsTVC.titleName = @"On My Way Messages";
       lookupSettingsTVC.footerDescription = @"On my way messages";
   }
   else if ([segue.identifier isEqualToString:@"PaymentTypesSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"PaymentType";
       lookupSettingsTVC.titleName = @"Payment Types";
       lookupSettingsTVC.footerDescription = @"Payment types for use with invoice payments.";
   }
   else if ([segue.identifier isEqualToString:@"LocationsSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"Location";
       lookupSettingsTVC.titleName = @"Locations";
       lookupSettingsTVC.footerDescription = @"Appliance locations used in certificates and records";
   }
   else if ([segue.identifier isEqualToString:@"VehicleRegistrationsSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"VehicleRegistration";
       lookupSettingsTVC.titleName = @"Vehicle Regs";
       lookupSettingsTVC.footerDescription = @"Vehicle registrations used to associate a mileage journey with a vehicle.";
   }
   else if ([segue.identifier isEqualToString:@"InvoiceStockCategoriesSegue"]) {
       LookupSettingsTVC *lookupSettingsTVC = segue.destinationViewController;
       lookupSettingsTVC.entityName = @"StockCategory";
       lookupSettingsTVC.titleName = @"Stock Categories";
       lookupSettingsTVC.footerDescription = @"Stock invoice categories used for grouping stock items in invoicing.";
   }

}


-(IBAction)logoutButtonPressed:(id)sender
{
    // save username and password
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:NO forKey:@"loggedIn"];
    [prefs synchronize];

}


// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}



@end
