//
//  PDFMaintenanceRecordRenderer.h
//  MasterGas
//
//  Created by Stephen Lalor on 13/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaintenanceServiceRecord.h"
#import "SDSyncEngine.h"
#import "ApplianceInspection.h"
#import "LACFileHandler.h"


@interface PDFMaintenanceRecordRenderer : NSObject


//+(void)drawPDF:(NSString*)fileName withCertificate:(Certificate *)certificate withInspection:(NSMutableArray *)applianceInspection;

+(void)drawPDF:(NSString*)fileName withMaintenanceRecord:(MaintenanceServiceRecord *)maintenanceRecord withCertificateReportLayoutName:(NSString *)reportLayoutName;


+(void)drawText;

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;

+(void)drawImage:(UIImage*)image inRect:(CGRect)rect;

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect;

+(void)drawLabels:(NSString*)reportLayoutName;

+(void)drawLogo:(NSString*)reportLayoutName;


+(void)drawTableAt:(CGPoint)origin
     withRowHeight:(int)rowHeight
    andColumnWidth:(int)columnWidth
       andRowCount:(int)numberOfRows
    andColumnCount:(int)numberOfColumns;


+(void)drawTableDataAt:(CGPoint)origin
         withRowHeight:(int)rowHeight
        andColumnWidth:(int)columnWidth
           andRowCount:(int)numberOfRows
        andColumnCount:(int)numberOfColumns;

@end
