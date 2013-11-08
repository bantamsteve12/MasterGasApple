//
//  ModelLookupTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 11/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplianceModel.h"


@class ModelLookupTVC;

@protocol ModelLookupTVCDelegate <NSObject>

- (void)theApplianceModelWasSelectedFromTheList:(ModelLookupTVC *)controller;
@end


@interface ModelLookupTVC : UITableViewController


@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSArray *applianceModels;
@property (nonatomic, strong) NSString *entityName;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) ApplianceModel *selectedApplianceModel;

- (IBAction)refreshButtonTouched:(id)sender;

@end
