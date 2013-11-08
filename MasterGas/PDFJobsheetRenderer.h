//
//  PDFJobsheetRenderer.h
//  MasterGas
//
//  Created by Stephen Lalor on 05/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jobsheet.h"
#import "SDSyncEngine.h"
#import "ApplianceInspection.h"
#import "LACFileHandler.h"


@interface PDFJobsheetRenderer : NSObject


+(void)drawPDF:(NSString*)fileName withJobsheet:(Jobsheet *)jobsheet withCertificateReportLayoutName:(NSString *)reportLayoutName;


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
