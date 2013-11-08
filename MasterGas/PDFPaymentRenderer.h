//
//  PDFPaymentRenderer.h
//  MasterGas
//
//  Created by Stephen Lalor on 17/08/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Payment.h"
#import "Invoice.h"
#import "SDSyncEngine.h"
#import "LACFileHandler.h"
#import "Company.h"


@interface PDFPaymentRenderer : NSObject


+(void)drawPDF:(NSString*)fileName withPayment:(Payment *)payment withInvoice:(Invoice *) invoice withCompanyRecord:(Company *)companyRecord withCertificateReportLayoutName:(NSString *)reportLayoutName;

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
