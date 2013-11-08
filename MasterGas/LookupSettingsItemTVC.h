//
//  LookupSettingsItemTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 04/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookupSettingsItemTVC : UITableViewController

@property (strong, nonatomic) NSManagedObjectID *managedObjectId;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) NSString *entityName;
@property (strong, nonatomic) NSString *titleName;
@property (strong, nonatomic) NSString *footerDescription;
@property bool itemIdRequired;

@property (strong, nonatomic) void (^updateCompletionBlock)(void);


@end

