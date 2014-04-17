//
//  GasTestingPurgingRenderer.h
//  MasterGas
//
//  Created by Stephen Lalor on 16/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NonDomesticPurgingTesting.h"
#import "LACFileHandler.h"

@interface GasTestingPurgingRenderer : NSObject

+(void)drawPDF:(NSString*)fileName withCertificate:(NonDomesticPurgingTesting *)certificate withCertificateReportLayoutName:(NSString *)reportLayoutName;

+(void)drawText;

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;

+(void)drawImage:(UIImage*)image inRect:(CGRect)rect;

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect;

+(void)drawLabels:(NSString*)reportLayoutName;

+(void)drawLabelsOnContinuationSheet:(NSString*)reportLayoutName;

+(void)drawLogo:(NSString*)reportLayoutName;


@end
