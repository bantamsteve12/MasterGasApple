//
//  LACFileHandler.h
//  MasterGas
//
//  Created by Stephen Lalor on 18/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Dropbox/Dropbox.h>

@interface LACFileHandler : NSObject


+ (BOOL ) saveFileInDocumentsDirectory:(NSString *) fileName subFolderName:(NSString *) folderName withData:(NSData *) fileData;
    
+ (UIImage *) getImageFromDocumentsDirectory:(NSString *) fileName subFolderName:(NSString *) folderName;

@end
