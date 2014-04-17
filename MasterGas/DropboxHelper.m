//
//  DropboxHelper.m
//  Grocery Dude
//
//  Created by Tim Roadley on 23/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//

#import "DropboxHelper.h"
#import "Objective-Zip.h"

@implementation DropboxHelper

#pragma mark - DROPBOX ACCOUNT
+ (void)linkToDropboxWithUI:(UIViewController*)controller {
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
    if (!account.isLinked) {
        NSLog(@"Linking to Dropbox...");
        [[DBAccountManager sharedManager] linkFromController:controller];
    } else {
        NSLog(@"Already linked to Dropbox as %@", account.info.displayName);
    }
}
+ (void)unlinkFromDropbox {
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
    if (account.isLinked) {
        [account unlink];
        NSLog(@"Unlinked from Dropbox");
    }
}

#pragma mark - LOCAL FILE MANAGEMENT



+ (NSURL*)renameLastPathComponentOfURL:(NSURL*)url toName:(NSString*)name {
    
    NSURL *urlPath = [url URLByDeletingLastPathComponent];
    NSURL *newURL = nil;
    
    if (name.length > 0) {
        newURL = [urlPath URLByAppendingPathComponent:name];
        NSError *error;
        [[NSFileManager defaultManager] moveItemAtPath:url.path
                                                toPath:newURL.path error:&error];
        
        if (error) {
            NSLog(@"ERROR renaming (i.e. moving) %@ to %@",
                  url.lastPathComponent, newURL.lastPathComponent);
        } else {
            NSLog(@"Renamed %@ to %@", url.lastPathComponent, newURL.lastPathComponent);
        }
    }
    else
    {
        NSURL *source = [url URLByAppendingPathComponent:@"MasterGas.sqlite"];
        newURL = [urlPath URLByAppendingPathComponent:@"MasterGas.sqlite"];
        
        NSError *error;
        [[NSFileManager defaultManager] moveItemAtPath:source.path
                                                toPath:newURL.path error:&error];
        
        NSURL *source2 = [url URLByAppendingPathComponent:@"MasterGas.sqlite-shm"];
        NSURL *newURL2 = [urlPath URLByAppendingPathComponent:@"MasterGas.sqlite-shm"];
        
        [[NSFileManager defaultManager] moveItemAtPath:source2.path
                                                toPath:newURL2.path error:&error];
        
        NSURL *source3 = [url URLByAppendingPathComponent:@"MasterGas.sqlite-wal"];
        NSURL *newURL3 = [urlPath URLByAppendingPathComponent:@"MasterGas.sqlite-wal"];
        
        [[NSFileManager defaultManager] moveItemAtPath:source3.path
                                                toPath:newURL3.path error:&error];
        
        
        if (error) {
            NSLog(@"ERROR renaming (i.e. moving) %@ to %@",
                  url.lastPathComponent, newURL.lastPathComponent);
        } else {
            NSLog(@"Renamed %@ to %@", url.lastPathComponent, newURL.lastPathComponent);
        
    }
  
    }
    return newURL;
}



+ (BOOL)deleteFileAtURL:(NSURL*)url {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:url.path error:&error];
        if (error) {NSLog(@"Error deleting %@", url.lastPathComponent);}
        else {NSLog(@"Deleted '%@'", url.lastPathComponent);return YES;}
    }
    return NO;
}
+ (void)createParentFolderForFile:(NSURL*)url {
    
    NSURL *parent = [url URLByDeletingLastPathComponent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:parent.path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtURL:parent
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:&error];
        if (error) {NSLog(@"Error creating directory: %@", error);}
    }
}

#pragma mark - DROPBOX FILE MANAGEMENT
+ (BOOL)fileExistsAtDropboxPath:(DBPath*)dropboxPath {
    
    DBFile *existingFile =
    [[DBFilesystem sharedFilesystem] openFile:dropboxPath error:nil];
    if (existingFile) {
        [existingFile close];
        return YES;
    }
    return NO;
}
+ (void)listFilesAtDropboxPath:(DBPath*)dropboxPath {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError *error = nil;
        NSArray *contents =
        [[DBFilesystem sharedFilesystem] listFolder:dropboxPath error:&error];
        if (contents) {
            NSLog(@"****** Dropbox Directory Contents (path /%@)",
                  dropboxPath.stringValue);
            for (DBFileInfo *info in contents) {
                float fileSize = info.size;
                NSLog(@" %@ (%.2fMB)", info.path, fileSize/1024/1024);
            }
            NSLog(@"******************************************");
            if (error) {
                NSLog(@"ERROR listing Dropbox contents for %@ : %@",
                      dropboxPath.stringValue, error);
            }
        } else {
            NSLog(@"Dropbox path '/%@' is empty", dropboxPath.stringValue);
        }
    });
}
+ (void)deleteFileAtDropboxPath:(DBPath*)dropboxPath {
    [[DBFilesystem sharedFilesystem] deletePath:dropboxPath error:nil];
}
+ (void)copyFileAtDropboxPath:(DBPath*)dropboxPath toURL:(NSURL*)url {
    
    DBError *openError = nil;
    DBFile *file = [[DBFilesystem sharedFilesystem] openFile:dropboxPath
                                                       error:&openError];
    if (openError) {
        NSLog(@"Error opening file '%@': %@", dropboxPath.stringValue, openError);
    }
    DBError *readError = nil;
    NSData *fileData = [file readData:&readError];
    if (readError) {
        NSLog(@"Error reading file '%@': %@", dropboxPath.stringValue, readError);
    }
    [self deleteFileAtURL:url];
    [[NSFileManager defaultManager] createFileAtPath:url.path
                                            contents:fileData
                                          attributes:nil];
}
+ (void)copyFileAtURL:(NSURL*)url toDropboxPath:(DBPath*)dropboxPath {
    
    NSLog(@"Copying %@ to Dropbox Path %@", url, dropboxPath);
    
    // Create File
    DBError *errorCreating;
    DBFile *file =
    [[DBFilesystem sharedFilesystem] createFile:dropboxPath error:&errorCreating];
    if (!file || errorCreating) {
        NSLog(@"Error creating file in Dropbox: %@", errorCreating);
    }
    
    // Write File
    DBError *errorWriting;
    if ([file writeContentsOfFile:url.path shouldSteal:NO error:&errorWriting]) {
        NSLog(@"Successfully copied %@ to Dropbox:%@",
              url.lastPathComponent, dropboxPath.stringValue);
    } else {
        NSLog(@"Error writing file to Dropbox: %@", errorWriting);
    }
}

#pragma mark - BACKUP / RESTORE
+ (NSURL*)zipFolderAtURL:(NSURL*)url withZipfileName:(NSString*)zipFileName {
    
   // NSURL *zipFileURL =
   // [[url URLByDeletingLastPathComponent] URLByAppendingPathComponent:zipFileName];
    
    NSURL *zipFileURL = [url URLByAppendingPathComponent:zipFileName];
    
    // Remove existing zip
    [self deleteFileAtURL:zipFileURL];
    
    // Create new zip
    ZipFile *zipFile =
    [[ZipFile alloc] initWithFileName:zipFileURL.path mode:ZipFileModeCreate];
    
    // Enumerate directory structure
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *directoryEnumerator =
    [fileManager enumeratorAtPath:url.path];
    
    // Write zip files for each file in the directory structure
    NSString *fileName;
    while (fileName = [directoryEnumerator nextObject]) {
        BOOL directory;
        NSString *filePath = [url.path stringByAppendingPathComponent:fileName];
        [fileManager fileExistsAtPath:filePath isDirectory:&directory];
        if (!directory) {
            
            // get file attributes
            NSError *error = nil;
            NSDictionary *attributes =
            [[NSFileManager defaultManager]attributesOfItemAtPath:filePath
                                                            error:&error];
            if (error) {
                NSLog(@"Failed to create zip, could not get file attributes. Error: %@",
                      error);
                return nil;
            } else {
               
                if ([fileName rangeOfString:@".pdf"].location == NSNotFound)
                {
                
                    NSDate *fileDate = [attributes objectForKey:NSFileCreationDate];
                    ZipWriteStream *stream =
              
                    [zipFile writeFileInZipWithName:fileName
                                           fileDate:fileDate
                                   compressionLevel:ZipCompressionLevelBest];
                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    
                
                    [stream writeData:data];
                    [stream finishedWriting];
                }
            }
        }
    }
    [zipFile close];
    
    return zipFileURL;
}
+ (void)unzipFileAtURL:(NSURL*)zipFileURL toURL:(NSURL*)unzipURL {
    
    @autoreleasepool {
        ZipFile *unzipFile = [[ZipFile alloc] initWithFileName:zipFileURL.path
                                                          mode:ZipFileModeUnzip];
        [unzipFile goToFirstFileInZip];
        for (int i = 0; i < [unzipFile numFilesInZip]; i++) {
            FileInZipInfo *info = [unzipFile getCurrentFileInZipInfo];
            [self createParentFolderForFile:
             [unzipURL URLByAppendingPathComponent:info.name]];
            NSLog(@"Unzipping '%@'...", info.name);
            ZipReadStream *read = [unzipFile readCurrentFileInZip];
            NSMutableData *data = [[NSMutableData alloc] initWithLength:info.length];
            [read readDataWithBuffer:data];
            [data writeToFile:[NSString stringWithFormat:@"%@/%@",
                               unzipURL.path, info.name] atomically:YES];
            [read finishedReading];
            [unzipFile goToNextFileInZip];
        }
        [unzipFile close];
    }
}
+ (void)restoreFromDropboxStoresZip:(NSString*)fileName
                 withCoreDataHelper:(SDCoreDataController*)cdh {
    
    [cdh.context performBlock:^{
        
        DBPath *zipFileInDropbox = [[DBPath alloc] initWithString:fileName];
        
       /* NSURL  *zipFileInSandbox =
        [[[cdh applicationStoresDirectory] URLByDeletingLastPathComponent]
         URLByAppendingPathComponent:fileName]; */
        
         NSURL  *zipFileInSandbox = [[cdh applicationStoresDirectory]
         URLByAppendingPathComponent:fileName];
      
        NSURL  *unzipFolder =
        [[cdh applicationStoresDirectory]
         URLByAppendingPathComponent:@"Stores_New"];
        NSURL *oldBackupURL =
        [[cdh applicationStoresDirectory]
         URLByAppendingPathComponent:@"Stores_Old"];
        
        [DropboxHelper copyFileAtDropboxPath:zipFileInDropbox
                                       toURL:zipFileInSandbox];
        [DropboxHelper unzipFileAtURL:zipFileInSandbox toURL:unzipFolder];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:unzipFolder.path]) {
            [DropboxHelper deleteFileAtURL:oldBackupURL];
         
            [DropboxHelper renameLastPathComponentOfURL:[cdh applicationStoresDirectory]
                                                 toName:@"Stores_Old"];
           
           
            
            NSURL  *file1 = [[cdh applicationStoresDirectory]
                                        URLByAppendingPathComponent:@"MasterGas.sqlite"];
            
            [DropboxHelper deleteFileAtURL:file1];
            
            
            
            NSURL  *file2 = [[cdh applicationStoresDirectory]
                              URLByAppendingPathComponent:@"MasterGas.sqlite-shm"];
            
            [DropboxHelper deleteFileAtURL:file2];
            
            
            NSURL  *file3 = [[cdh applicationStoresDirectory]
                              URLByAppendingPathComponent:@"MasterGas.sqlite-wal"];
            
            [DropboxHelper deleteFileAtURL:file3];
            
            
            [DropboxHelper renameLastPathComponentOfURL:unzipFolder
                                                 toName:@""];
            if ([cdh reloadStore]) {
          
                
            [DropboxHelper deleteFileAtURL:oldBackupURL];
        
            [DropboxHelper deleteFileAtURL:unzipFolder];
                
            
                UIAlertView *confirmAlert = [[UIAlertView alloc]
                                          initWithTitle:@"Restore Complete"
                                          message:@"All data has been restored from the selected backup"
                                          delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
                [confirmAlert show];
               
                [NSThread sleepForTimeInterval:3];
                
                exit(0);
               
                
            } else { // Attempt Recovery
                [DropboxHelper renameLastPathComponentOfURL:[cdh applicationStoresDirectory]
                                                     toName:@"Stores_FailedRestore"];
                [DropboxHelper renameLastPathComponentOfURL:oldBackupURL
                                                     toName:@"Stores"];
                [DropboxHelper deleteFileAtURL:oldBackupURL];
                if (![cdh reloadStore]) {
                    UIAlertView *failAlert = [[UIAlertView alloc]
                                              initWithTitle:@"Failed to Restore"
                                              message:@"Please try to restore from another backup"
                                              delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Close", nil];
                    [failAlert show];
                }
            }
        }
    }];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Restore Complete"] && buttonIndex == 0) {
         exit(0);
    }
}


@end
