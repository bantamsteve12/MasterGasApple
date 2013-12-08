//
//  FooterNotesTVC.m
//  MasterGas
//
//  Created by Stephen Lalor on 03/12/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "FooterNotesTVC.h"
#import "SDCoreDataController.h"
#import "LACHelperMethods.h"


@interface FooterNotesTVC ()
@property CGPoint originalCenter;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;

@end

@implementation FooterNotesTVC


@synthesize entityName;


@synthesize estimateFooterNotesTextViewField;
@synthesize invoiceFooterNotesTextViewField;

@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize footerNotes;
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
    
    [self loadRecordsFromCoreData];
    
    if (self.footerNotes.count < 1) {
        
        self.managedObject = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    }
    else{
        self.managedObject = [self.footerNotes objectAtIndex:0];
    }
    
   self.estimateFooterNotesTextViewField.text = [self.managedObject valueForKey:@"estimateFooterNotes"];
    self.invoiceFooterNotesTextViewField.text = [self.managedObject valueForKey:@"invoiceFooterNotes"];
    
}

- (void)loadRecordsFromCoreData {
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
        
        NSLog(@"entity: %@", self.entityName);
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"companyId" ascending:YES]]];
        //   [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        self.footerNotes = [self.managedObjectContext executeFetchRequest:request error:&error];
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


- (IBAction)saveButtonTouched:(id)sender {
    
    
    [self.managedObject setValue:self.estimateFooterNotesTextViewField.text forKey:@"estimateFooterNotes"];
    [self.managedObject setValue:self.invoiceFooterNotesTextViewField.text forKey:@"invoiceFooterNotes"];
  
    
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
    // updateCompletionBlock();
    
    [LACHelperMethods setFooterPreferencesInNSDefaults:self.managedObjectContext];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
