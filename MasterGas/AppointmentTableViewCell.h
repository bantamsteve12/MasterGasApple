//
//  AppointmentTableViewCell.h
//  MasterGas
//
//  Created by Stephen Lalor on 02/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailLabel;

@end