//
//  PlantCommissioningRenderer.h
//  MasterGas
//
//  Created by Stephen Lalor on 24/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlantCommissioningService.h"
#import "PlantComServiceApplianceInspection.h"
#import "LACFileHandler.h"


@interface PlantCommissioningRenderer : NSObject

+(void)drawPDF:(NSString*)fileName withCertificate:(PlantCommissioningService *)certificate withInspection:(NSArray *)applianceInspections withCertificateReportLayoutName:(NSString *)reportLayoutName;

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
