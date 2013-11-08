//
//  BreakdownServiceAdditionalNotesTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 14/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Additions.h"

@interface BreakdownServiceAdditionalNotesTVC : UITableViewController


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;


@property (strong, nonatomic) IBOutlet UITextView *additionalNotesTextView;
@property (strong, nonatomic) IBOutlet UITextView *sparesRequiredTextView;

@property (strong, nonatomic) NSString *entityName;


@end
