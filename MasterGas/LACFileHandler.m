//
//  LACFileHandler.m
//  MasterGas
//
//  Created by Stephen Lalor on 18/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "LACFileHandler.h"

@implementation LACFileHandler

+ (BOOL ) saveFileInDocumentsDirectory:(NSString *) fileName subFolderName:(NSString *) folderName withData:(NSData *) fileData   {
    
    // save file to documents folder
    NSString *fullPath = [NSString stringWithFormat:@"/%@/%@", folderName, fileName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *dataPath = [documentsPath stringByAppendingPathComponent:folderName];
    NSString *filePath = [dataPath stringByAppendingPathComponent:fileName]; //Add the file name
    
    // check that the folder exists. Create if required.
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        
        NSError* error;
        if(  [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error])
            ;// success
        else
        {
            NSLog(@"[%@] ERROR: attempting to write create MyFolder directory", [self class]);
            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
            return NO;
        }
    }
    
    [fileData writeToFile:filePath atomically:YES]; //Write the file
    
    // check dropbox enabled and save if required.
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
    
    if (account.linked) {
        DBPath *path = [[DBPath root] childPath:fullPath];
        DBFileInfo *fileInfo = [[DBFilesystem sharedFilesystem] fileInfoForPath:path error:nil];
        
        if (fileInfo == nil) {
            NSLog(@"fileInfo not present");
            DBFile *file = [[DBFilesystem sharedFilesystem] createFile:path error:nil];
            [file writeData:fileData error:nil];
        }
        else
        {
            DBFile *file = [[DBFilesystem sharedFilesystem] openFile:path error:nil];
            [file writeData:fileData error:nil];
        }
    }
    
   // return bool value to say if successful or not.
    return NO;
}



+ (UIImage *) getImageFromDocumentsDirectory:(NSString *) fileName subFolderName:(NSString *) folderName
{

    NSString *fullPath = [NSString stringWithFormat:@"/%@/%@", folderName, fileName];
    // check dropbox enabled and save if required.
   
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
    
    if (account.linked) {
        DBPath *path = [[DBPath root] childPath:fullPath];
        DBFile *file = [[DBFilesystem sharedFilesystem] openFile:path error:nil];
        UIImage *image = [[UIImage alloc] initWithData:[file readData:nil]];
        return image;
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *dataPath = [documentsPath stringByAppendingPathComponent:folderName];
        NSString *filePath = [dataPath stringByAppendingPathComponent:fileName]; //Add the file name
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
        return image;
    }
}


@end
