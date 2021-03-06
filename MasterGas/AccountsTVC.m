//
//  AccountsTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 21/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "AccountsTVC.h"
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"
#import "LACHelperMethods.h"

@interface AccountsTVC ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@end

@implementation AccountsTVC

@synthesize invoices;
@synthesize estimates;

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
    self.managedObjectContext = [[SDCoreDataController sharedInstance] newManagedObjectContext];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"CreateNewInvoiceSegue"]) {
        
        // perform your computation to determine whether segue should occur
        BOOL segueShouldOccur = NO; // you determine this
        
        [self loadInvoicesDataFromCoreData];
        
        NSLog(@"invoice count: %i", [self.invoices count]);
        
        if (self.invoices.count < 3 || [LACHelperMethods fullUser]) {
            
            segueShouldOccur = YES;
        }
        
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Upgrade required"
                                         message:@"To add more invoices you need to upgrade to the pro account."
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            // prevent segue from occurring
            return NO;
        }
    }
    
    else  if ([identifier isEqualToString:@"CreateNewEstimateSegue"]) {
        
        // perform your computation to determine whether segue should occur
        BOOL segueShouldOccur = NO; // you determine this
        
        [self loadEstimatesDataFromCoreData];
        
        
        if (self.estimates.count < 3 || [LACHelperMethods fullUser]) {
            
            segueShouldOccur = YES;
        }
        
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Upgrade required"
                                         message:@"To add more estimates you need to upgrade to the pro account."
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            // prevent segue from occurring
            return NO;
        }
    }
    // by default perform the segue transition
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"ReceiveAPaymentSegue"]) {
        InvoicesTVC *invoicesTVC = segue.destinationViewController;
        invoicesTVC.outstanding = YES;
    }
    else if ([segue.identifier isEqualToString:@"ViewOutstandingInvoicesSegue"]) {
        InvoicesTVC *invoicesTVC = segue.destinationViewController;
        invoicesTVC.outstanding = YES;
    }
    else if ([segue.identifier isEqualToString:@"CreateNewInvoiceSegue"]) {
    }
    else if ([segue.identifier isEqualToString:@"CreateNewEstimateSegue"]) {
    }
}


- (void)loadInvoicesDataFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Invoice"];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"companyId" ascending:YES]]];
        
        self.invoices = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        NSLog(@"no of invoices = %i", [self.invoices count]);
        
    }];
}


- (void)loadEstimatesDataFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Estimate"];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"companyId" ascending:YES]]];
        
        self.estimates = [self.managedObjectContext executeFetchRequest:request error:&error];
       
        
    }];
}


@end



//CreateNewInvoiceSegue