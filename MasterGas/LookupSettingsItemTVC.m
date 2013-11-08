//
//  LookupSettingsItemTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 04/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "LookupSettingsItemTVC.h"
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"
#import "NSString+Additions.h"

@interface LookupSettingsItemTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@end

@implementation LookupSettingsItemTVC

@synthesize entityName;
@synthesize titleName;
@synthesize footerDescription;

@synthesize nameTextField;
@synthesize itemIdRequired;
@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize managedObjectId;

@synthesize updateCompletionBlock;


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
    
    if (self.managedObjectId == nil) {
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
     
        if (itemIdRequired)
        {
            [self.managedObject setValue:[NSString stringWithFormat:@"ITEMID-%@", [NSString generateUniqueIdentifier]] forKey:@"itemId"];
        }
    }
    else{
        self.managedObject = [managedObjectContext objectWithID:self.managedObjectId];
    }
    
    self.nameTextField.text = [self.managedObject valueForKey:@"name"];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.originalCenter = self.view.center;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return self.footerDescription;
}


- (IBAction)saveButtonTouched:(id)sender {
    
    
    if (![self.nameTextField.text isEqualToString:@""]) {
        
        [self.managedObject setValue:self.nameTextField.text forKey:@"name"];
        
        NSString *objectId = [self.managedObject valueForKey:@"objectId"];
        
        NSLog(@"objectId: %@", objectId);
        
        if (objectId.length > 1) {
            [self.managedObject setValue:[NSNumber numberWithInt:SDObjectEdited] forKey:@"syncStatus"];
        }
        else
        {
            [self.managedObject setValue:[NSNumber numberWithInt:SDObjectCreated] forKey:@"syncStatus"];
        }
        
        
        
        [self.managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            BOOL saved = [self.managedObjectContext save:&error];
            if (!saved) {
                // do some real error handling
                NSLog(@"Could not save Date due to %@", error);
            }
            [[SDCoreDataController sharedInstance] saveMasterContext];
        }];
        
        [self.navigationController popViewControllerAnimated:YES];
        updateCompletionBlock();
        
    } else {
        UIAlertView *cannotSaveAlert = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"You must at least set a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [cannotSaveAlert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
