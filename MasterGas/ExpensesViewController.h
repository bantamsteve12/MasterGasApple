//
//  ExpensesViewController.h
//  MasterGas
//
//  Created by Stephen Lalor on 06/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Expense.h"
#import "SDSyncEngine.h"
#import "MBProgressHUD.h"
#import "LACUsersHandler.h"

@interface ExpensesViewController : UIViewController <MFMailComposeViewControllerDelegate, UIActionSheetDelegate, MBProgressHUDDelegate> {
	MBProgressHUD *HUD;
}


@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) Expense *currentExpense;
@property (nonatomic, strong) NSArray *expenseItems;
@property (nonatomic, strong) NSArray *companyRecords;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@property (strong, nonatomic) NSString *mode;

@property (retain, nonatomic) Expense *aExpense;


-(void)showPDFFile;
-(NSString*)getPDFFileName;
@end
