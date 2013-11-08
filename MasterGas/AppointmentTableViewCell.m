//
//  AppointmentTableViewCell.m
//  MasterGas
//
//  Created by Stephen Lalor on 02/12/2012.
//  Copyright (c) 2012 Stephen Lalor. All rights reserved.
//

#import "AppointmentTableViewCell.h"

@implementation AppointmentTableViewCell

@synthesize textLabel;
@synthesize detailLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
