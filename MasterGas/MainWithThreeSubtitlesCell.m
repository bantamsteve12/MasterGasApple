//
//  MainWithThreeSubtitlesCell.m
//  MasterGas
//
//  Created by Stephen Lalor on 05/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "MainWithThreeSubtitlesCell.h"

@implementation MainWithThreeSubtitlesCell

@synthesize textLabel;
@synthesize subtitleOneLabel;
@synthesize subtitleTwoLabel;
@synthesize subtitleThreeLabel;
@synthesize subtitleFourLabel;

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
