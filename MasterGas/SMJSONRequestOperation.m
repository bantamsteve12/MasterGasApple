//
//  SMJSONRequestOperation.m
//  MasterGas
//
//  Created by Stephen Lalor on 10/05/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "SMJSONRequestOperation.h"

@implementation SMJSONRequestOperation

+ (NSSet *)acceptableContentTypes {
    NSSet *defaultAcceptableContentTypes = [super acceptableContentTypes];
    return [defaultAcceptableContentTypes setByAddingObject:@"application/vnd.stackmob+json"];
}

@end
