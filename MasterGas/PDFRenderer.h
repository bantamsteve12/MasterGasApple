//
//  PDFRenderer.h
//  MasterGas
//
//  Created by Stephen Lalor on 03/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Certificate.h"
#import "SDSyncEngine.h"
#import "ApplianceInspection.h"
#import "LACFileHandler.h"

@interface PDFRenderer : NSObject



//+(void)drawPDF:(NSString*)fileName withCertificate:(Certificate *)certificate withInspection:(NSMutableArray *)applianceInspections withCertificateReportLayoutName:(NSString *)reportLayoutName;

+(void)drawPDF:(NSString*)fileName withCertificate:(Certificate *)certificate withInspection:(NSArray *)applianceInspections withCertificateReportLayoutName:(NSString *)reportLayoutName;



+(void)drawText;

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;

+(void)drawImage:(UIImage*)image inRect:(CGRect)rect;

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect;

+(void)drawLabels:(NSString*)reportLayoutName;

+(void)drawLabelsOnContinuationSheet:(NSString*)reportLayoutName;

+(void)drawLogo:(NSString*)reportLayoutName;

+(BOOL)shouldUseContinuation;

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
