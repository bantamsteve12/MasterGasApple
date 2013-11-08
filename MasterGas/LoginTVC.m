//
//  LoginTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 28/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "LoginTVC.h"
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"
#import "RegisterTVC.h"


@interface LoginTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@end

@implementation LoginTVC


@synthesize entityName;

@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize companyRecords;

//@synthesize updateCompletionBlock;

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
    
    [self loadRecordsFromCoreData];
    
    self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    
    
}



 - (void)loadRecordsFromCoreData {
 [self.managedObjectContext performBlockAndWait:^{
 [self.managedObjectContext reset];
 NSError *error = nil;
 NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
 
 NSLog(@"entity: %@", self.entityName);
 
 [request setSortDescriptors:[NSArray arrayWithObject:
 [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
 [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
 
// TODO set predicate to take actual companyId
// [request setPredicate:[NSPredicate predicateWithFormat:@"companyId = %@", @"12345"]];
 self.companyRecords = [self.managedObjectContext executeFetchRequest:request error:&error];
 }];
 } 


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //  self.originalCenter = self.view.center;
}


-(IBAction)cancelButtonTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)loginButtonTouched:(id)sender
{
    NSLog(@"company record = %i", companyRecords.count);
    
    
    
    if (self.companyRecords.count > 0) {
       self.managedObject = [self.companyRecords objectAtIndex:0];
        
        
        NSString *username = [self.managedObject valueForKey:@"username"];
        NSString *password = [self.managedObject valueForKey:@"password"];
        
        
        NSLog(@"username: %@", username);
        NSLog(@"username field value: %@", self.usernameTextField.text);
        NSLog(@"password: %@", password);
        NSLog(@"password field value: %@", self.passwordTextField.text);
        
        
        
        if ([username isEqualToString:self.usernameTextField.text]) {
            if ([password isEqualToString:self.passwordTextField.text]) {
                
                NSLog(@"username and password ok");
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:@"username" forKey:@"username"];
                [prefs setObject:@"password" forKey:@"password"];
                [prefs setObject:[self.managedObject valueForKey:@"companyId"] forKey:@"companyId"];
                
                // TODO change to pickup engineer Id
                [prefs setObject:@"00001" forKey:@"engineerId"];
                
                
                [prefs synchronize];
                [self dismissModalViewControllerAnimated:YES];
                
            }
            else
            {
                NSLog(@"Username or password incorrect");
            }
        }
        else{
            NSLog(@"Username or password incorrect");
        }
    }
    else
    {
        NSLog(@"ERROR: More than one company record!");
    }
    
    
  

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
