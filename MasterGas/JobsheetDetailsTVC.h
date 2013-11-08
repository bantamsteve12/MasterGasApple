//
//  JobsheetDetailsTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 05/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Additions.h"


@interface JobsheetDetailsTVC : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UITextView *jobNotesTextView;
@property (strong, nonatomic) IBOutlet UITextView *sparesUsedTextView;
@property (strong, nonatomic) IBOutlet UITextView *sparesRequiredTextView;
@property (strong, nonatomic) IBOutlet UITextView *materialsPurcasedTextView;

@property (strong, nonatomic) NSString *entityName;


@end
