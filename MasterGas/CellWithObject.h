//
//  CellWithObject.h
//  MasterGas
//
//  Created by Stephen Lalor on 18/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellWithObject : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailLabel;
@property (nonatomic, strong) NSObject *object;

@end


