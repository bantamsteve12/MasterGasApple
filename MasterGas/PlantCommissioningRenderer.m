//
//  PlantCommissioningRenderer.m
//  MasterGas
//
//  Created by Stephen Lalor on 24/03/2014.
//  Copyright (c) 2014 Stephen Lalor. All rights reserved.
//

#import "PlantCommissioningRenderer.h"
#import "CoreText/CoreText.h"
#import "UIColor+Additions.h"
#import "PlantCommissioningService.h"
#import "PlantComServiceApplianceInspection.h"
#import "NSString+Additions.h"

@implementation PlantCommissioningRenderer


PlantCommissioningService *cert;

NSArray *applianceInspectionsArray;

+(BOOL)shouldUseContinuation
{
    
    
    BOOL shouldUseContinuation = NO;
    
    /*
    for (int i = 0; i < [applianceInspectionsArray count]; i++)
    {
        ApplianceInspection *inspection = applianceInspectionsArray[i];
        
        if ([inspection.faultDetails contains:@"\n"]) {
            shouldUseContinuation = YES;
        }
        if ([inspection.faultDetails length] > 50) {
            shouldUseContinuation = YES;
        }
        
        if ([inspection.remedialActionTaken contains:@"\n"]) {
            shouldUseContinuation = YES;
        }
        if ([inspection.remedialActionTaken length] > 50) {
            shouldUseContinuation = YES;
        }
    } */
    
    return shouldUseContinuation;
}

+(void)drawPDF:(NSString*)fileName withCertificate:(PlantCommissioningService *)certificate withInspection:(NSArray *)applianceInspections withCertificateReportLayoutName:(NSString *)reportLayoutName
{
    
    applianceInspectionsArray = applianceInspections;
    cert = certificate;
    
    NSLog(@"certificate = %@", certificate.certificateNumber);
    NSLog(@"cert = %@", cert.certificateNumber);
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 792, 612), nil);
    
    [self drawLabels:reportLayoutName];
    [self drawLogo:reportLayoutName];
    // [self drawLogo:reportLayoutName];
    
  
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 792, 612), nil);
    [self drawLabels:@"PlantCommissioningServiceNonDomCont"];
    [self drawLogo:@"PlantCommissioningServiceNonDomCont"];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}


+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};
    
    CGColorRef color = CGColorCreate(colorspace, components);
    
    CGContextSetStrokeColorWithColor(context, color);
    
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
    
}


+(void)drawImage:(UIImage*)image inRect:(CGRect)rect
{
    
    [image drawInRect:rect];
    
}


+(void)drawRect:(CGRect)rect withUILabel:(UILabel*)label {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rectangle = CGRectMake(rect.origin.x-2, rect.origin.y, rect.size.width, rect.size.height);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    
    
    UIColor *backgroundColor;
    
    if (label.tag == 0) {
        backgroundColor   = [UIColor colorWithR:54 G:100 B:139 A:1];
    }
    else if(label.tag == 1)
    {
        backgroundColor = [UIColor colorWithR:214 G:214 B:214 A:1];
    }
    else if(label.tag == 4)
    {
        backgroundColor = [UIColor clearColor];
    }
    else if(label.tag == 5)
    {
        backgroundColor = [UIColor colorWithR:214 G:214 B:214 A:1];
    }
    else if(label.tag == 8 || label.tag == 9)
    {
        backgroundColor   = [UIColor colorWithR:54 G:100 B:139 A:1];
        
    }
    else if (label.tag == 333) {
        backgroundColor   = [UIColor colorWithR:54 G:100 B:139 A:1];
    }
    else if(label.tag == 1101)
    {
        if ([self shouldUseContinuation]) {
            backgroundColor   = [UIColor colorWithR:235 G:235 B:235 A:1];
        }
        else
        {
            backgroundColor   = [UIColor  clearColor];
        }
    }
    else
    {
        backgroundColor = [UIColor colorWithR:235 G:235 B:235 A:1];
    }
    
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rectangle);
}


+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect withUILabel:(UILabel*)label
{
 
    UIColor *textColor;
    CGColorRef color;
    CTFontRef font;
    CTTextAlignment theAlignment;
    
    if (label.tag == 0) {
        textColor = [UIColor whiteColor];
        color = textColor.CGColor;
        font = CTFontCreateWithName((CFStringRef) @"System",12.0, NULL);
        theAlignment = kCTCenterTextAlignment;
    }
    else if(label.tag == 4)
    {
        textColor = [UIColor blackColor];
        color = textColor.CGColor;
        theAlignment = kCTCenterTextAlignment;
        font = CTFontCreateWithName((CFStringRef) @"System", 18.0, NULL);
    }
    else if (label.tag == 5)
    {
        textColor = [UIColor blackColor];
        color = textColor.CGColor;
        theAlignment = kCTCenterTextAlignment;
        font = CTFontCreateWithName((CFStringRef) @"System", 7.0, NULL);
    }
    else if (label.tag == 8)
    {
        textColor = [UIColor whiteColor];
        color = textColor.CGColor;
        theAlignment = kCTCenterTextAlignment;
        font = CTFontCreateWithName((CFStringRef) @"System", 9.0, NULL);
    }
    else if (label.tag == 9)
    {
        textColor = [UIColor whiteColor];
        color = textColor.CGColor;
        theAlignment = kCTCenterTextAlignment;
        font = CTFontCreateWithName((CFStringRef) @"System", 8.0, NULL);
    }
    else if(label.tag >= 59 && label.tag <= 68)
    {
        textColor = [UIColor blackColor];
        color = textColor.CGColor;
        theAlignment = kCTLeftTextAlignment;
        font = CTFontCreateWithName((CFStringRef) @"System", 7.0, NULL);
    }
    else if(label.tag == 333)
    {
        textColor = [UIColor whiteColor];
        color = textColor.CGColor;
        font = CTFontCreateWithName((CFStringRef) @"System",14.0, NULL);
        theAlignment = kCTCenterTextAlignment;
    }
    else if(label.tag == 1101)
    {
        textColor = [UIColor blackColor];
        color = textColor.CGColor;
        font = CTFontCreateWithName((CFStringRef) @"System",33.0, NULL);
        theAlignment = kCTCenterTextAlignment;
    }
    else
    {
        textColor = [UIColor blackColor];
        color = textColor.CGColor;
        theAlignment = kCTLeftTextAlignment;
        font = CTFontCreateWithName((CFStringRef) @"System", 8.0, NULL);
    }
    
    CFIndex theNumberOfSettings = 1;
    CTParagraphStyleSetting theSettings[1] =
    {
        { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment),
            &theAlignment }
    };
    
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
    
    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)(font), (NSString *)kCTFontAttributeName,
                                    color, (NSString *)kCTForegroundColorAttributeName,
                                    paragraphStyle, (NSString *) kCTParagraphStyleAttributeName,
                                    nil];
    
    
    NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:textToDraw attributes:attributesDict];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)stringToDraw);
    
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get the graphics context.
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    
    
    [self drawRect:frameRect withUILabel:label];
    
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2 + frameRect.size.height);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame
    CTFrameDraw(frameRef, currentContext);
    
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2 - frameRect.size.height);
    
    CFRelease(frameRef);
    // CFRelease(stringRef);
    CFRelease(framesetter);
    
}


+(void)drawLabels:(NSString*)reportLayoutName
{
    
    NSLog(@"report name: %@", reportLayoutName);
    
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:reportLayoutName owner:nil options:nil];
    
    UIView* mainView = [objects objectAtIndex:0];
    
    for (UIView* view in [mainView subviews]) {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*)view;
            
            
            switch(label.tag)
            {
                case 10:{
                    NSString *str = cert.customerAddressName;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 11:{
                    NSString *str = cert.customerAddressLine1;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 12:{
                    NSString *str = cert.customerAddressLine2;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 13:{
                    NSString *str = cert.customerAddressLine3;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 14:{
                    NSString *str = cert.customerPostcode;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 15:{
                    NSString *str = cert.customerTelNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 16:{
                    NSString *str = cert.siteAddressName;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 17:{
                    NSString *str = cert.siteAddressLine1;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 18:{
                    NSString *str = cert.siteAddressLine2;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 19:{
                    NSString *str = cert.siteAddressLine3;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 20:{
                    NSString *str = cert.siteAddressPostcode;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 21:{
                    NSString *str = cert.siteTelNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 22:{
                    NSString *str = cert.engineerSignoffEngineerName;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 23:{
                    NSString *str = cert.engineerSignoffEngineerIDCardRegNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 24:{
                    NSString *str = cert.engineerSignoffTradingTitle;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 25:{
                    NSString *str = cert.engineerSignoffAddressLine1;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 26:{
                    NSString *str = cert.engineerSignoffAddressLine2;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 27:{
                    NSString *str = cert.engineerSignoffAddressLine3;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 28:{
                    NSString *str = cert.engineerSignoffPostcode;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 29:{
                    NSString *str = cert.engineerSignoffTelNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 30:{
                    NSString *str = cert.certificateNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 31:{
                    NSString *str = cert.referenceNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 32:{
                    NSString *str = cert.engineerSignoffCompanyGasSafeRegNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                #pragma Appliance One
                    
                case 401:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                    
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 402:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.type;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 403:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.manufacturer;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                case 404:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.model;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                case 405:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.serialNumber;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
            
                    
                case 406:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.burnerManufacturer;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                    
                    
                    
                case 407:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.flueType;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 408:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLHeatInputRating;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
               
                case 409:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHHeatInputRating;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 410:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLGasBurnerPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 411:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHGasBurnerPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 412:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLGasRate;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
             
                case 413:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHGasRate;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
              
                case 414:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLAirGasRatioSetting;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 415:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHAirGasRatioSetting;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 416:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLAmbientRoomTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 417:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHAmbientRoomTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 418:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLFlueGasTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                
                case 419:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHFlueGasTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 420:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLFlueGasTempNet;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                case 421:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHFlueGasTempNet;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 422:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLFlueDraughtPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                    
                case 423:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHFlueDraughtPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                case 424:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLOxygen;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                case 425:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHOxygen;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                case 426:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLCarbonMonoxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                
                case 427:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHCarbonMonoxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 428:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLCarbonDioxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 429:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHCarbonDioxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 430:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLNOX;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 431:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHNOX;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
             
                case 432:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLExcessAir;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                case 433:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHExcessAir;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 434:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLCOCO2Ratio;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                    
                case 435:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHCOCO2Ratio;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                case 436:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLGrossEfficiency;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}


                case 437:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHGrossEfficiency;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 438:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccLCOFlueDilution;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 439:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.ccHCOFlueDilution;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 440:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acFlueFlowSatisfactory;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                
                case 441:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acSpilageTestSatisfactory;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                
                case 442:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acVentilationSatisfactory;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 443:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acAirGasPressureSwitchWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                    
                case 444:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acFlameProvingSafetyDevicesWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 445:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acBurnerLockoutTime;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                
                case 446:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acTempAndThermostatsWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 447:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acApplianceServiced;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 448:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acGasBoostersCompressorsWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                
                case 449:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acGasInstallationTightnessTestCarriedOut;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 450:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acGasInstallationPipeworkSupported;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 451:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acGasInstallationPipeworkSleevedLabelledPainted;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                
                case 452:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acChimneyInstalledwithStandards;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                 
                case 453:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.acFanFlueInterlockWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 460:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.workCarriedOut;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 461:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.remedialWorkRequired;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 462:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.warningNoticeNumber;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 463:
                {
                    if (applianceInspectionsArray.count > 0) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.warningNoticeIssued;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
        #pragma Appliance Two
                    
                    
                    
                case 501:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 502:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.type;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 503:
                {
                    if (applianceInspectionsArray.count > 1) {
                    PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                    
                        NSString *str = applianceInspection.manufacturer;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 504:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.model;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 505:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.serialNumber;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 506:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.burnerManufacturer;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 507:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.flueType;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 508:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLHeatInputRating;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 509:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHHeatInputRating;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 510:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLGasBurnerPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 511:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                    
                        NSString *str = applianceInspection.ccHGasBurnerPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 512:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLGasRate;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 513:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHGasRate;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 514:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLAirGasRatioSetting;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 515:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHAirGasRatioSetting;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 516:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLAmbientRoomTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 517:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHAmbientRoomTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 518:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLFlueGasTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 519:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHFlueGasTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 520:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLFlueGasTempNet;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 521:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHFlueGasTempNet;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 522:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];;
                        
                        NSString *str = applianceInspection.ccLFlueDraughtPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 523:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHFlueDraughtPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 524:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLOxygen;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 525:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHOxygen;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 526:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLCarbonMonoxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 527:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHCarbonMonoxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 528:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLCarbonDioxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 529:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHCarbonDioxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 530:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLNOX;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 531:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHNOX;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 532:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLExcessAir;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 533:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHExcessAir;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 534:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLCOCO2Ratio;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 535:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHCOCO2Ratio;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 536:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLGrossEfficiency;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 537:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHGrossEfficiency;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 538:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccLCOFlueDilution;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 539:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.ccHCOFlueDilution;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 540:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acFlueFlowSatisfactory;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 541:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acSpilageTestSatisfactory;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 542:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acVentilationSatisfactory;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 543:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acAirGasPressureSwitchWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 544:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acFlameProvingSafetyDevicesWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 545:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acBurnerLockoutTime;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 546:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acTempAndThermostatsWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 547:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acApplianceServiced;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 548:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acGasBoostersCompressorsWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 549:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acGasInstallationTightnessTestCarriedOut;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 550:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acGasInstallationPipeworkSupported;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 551:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acGasInstallationPipeworkSleevedLabelledPainted;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 552:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acChimneyInstalledwithStandards;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 553:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.acFanFlueInterlockWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 560:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.workCarriedOut;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 561:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.remedialWorkRequired;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 562:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.warningNoticeNumber;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 563:
                {
                    if (applianceInspectionsArray.count > 1) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.warningNoticeIssued;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    

            #pragma Appliance Three
            
                case 601:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 602:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.type;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 603:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.manufacturer;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 604:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.model;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 605:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.serialNumber;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 606:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.burnerManufacturer;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 607:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.flueType;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 608:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLHeatInputRating;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 609:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHHeatInputRating;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 610:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLGasBurnerPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 611:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHGasBurnerPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 612:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLGasRate;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 613:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHGasRate;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 614:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLAirGasRatioSetting;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 615:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHAirGasRatioSetting;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 616:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLAmbientRoomTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 617:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHAmbientRoomTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 618:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLFlueGasTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 619:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHFlueGasTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 620:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLFlueGasTempNet;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 621:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHFlueGasTempNet;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 622:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLFlueDraughtPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 623:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHFlueDraughtPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 624:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLOxygen;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 625:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHOxygen;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 626:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLCarbonMonoxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 627:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHCarbonMonoxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 628:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLCarbonDioxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 629:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHCarbonDioxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 630:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLNOX;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 631:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHNOX;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 632:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLExcessAir;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 633:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHExcessAir;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 634:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLCOCO2Ratio;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 635:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHCOCO2Ratio;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 636:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLGrossEfficiency;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 637:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHGrossEfficiency;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 638:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccLCOFlueDilution;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 639:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.ccHCOFlueDilution;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 640:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acFlueFlowSatisfactory;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 641:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acSpilageTestSatisfactory;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 642:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acVentilationSatisfactory;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 643:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acAirGasPressureSwitchWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 644:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acFlameProvingSafetyDevicesWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 645:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acBurnerLockoutTime;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 646:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acTempAndThermostatsWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 647:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acApplianceServiced;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 648:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acGasBoostersCompressorsWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 649:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acGasInstallationTightnessTestCarriedOut;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 650:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acGasInstallationPipeworkSupported;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 651:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acGasInstallationPipeworkSleevedLabelledPainted;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 652:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acChimneyInstalledwithStandards;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 653:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.acFanFlueInterlockWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
              
                case 660:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.workCarriedOut;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 661:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.remedialWorkRequired;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 662:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.warningNoticeNumber;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 663:
                {
                    if (applianceInspectionsArray.count > 2) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.warningNoticeIssued;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
        #pragma Appliance Four
                    
                    
                case 701:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 702:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.type;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 703:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.manufacturer;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 704:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.model;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 705:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.serialNumber;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 706:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.burnerManufacturer;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 707:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.flueType;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 708:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLHeatInputRating;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 709:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHHeatInputRating;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 710:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLGasBurnerPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 711:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHGasBurnerPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 712:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLGasRate;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 713:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHGasRate;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 714:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLAirGasRatioSetting;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 715:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHAirGasRatioSetting;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 716:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLAmbientRoomTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 717:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHAmbientRoomTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 718:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLFlueGasTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 719:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHFlueGasTemp;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 720:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLFlueGasTempNet;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 721:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHFlueGasTempNet;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 722:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLFlueDraughtPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 723:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHFlueDraughtPressure;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 724:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLOxygen;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 725:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHOxygen;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 726:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLCarbonMonoxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 727:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHCarbonMonoxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 728:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLCarbonDioxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 729:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHCarbonDioxide;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 730:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLNOX;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 731:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHNOX;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 732:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLExcessAir;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 733:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHExcessAir;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 734:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLCOCO2Ratio;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 735:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHCOCO2Ratio;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 736:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLGrossEfficiency;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 737:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHGrossEfficiency;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 738:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccLCOFlueDilution;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 739:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.ccHCOFlueDilution;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 740:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acFlueFlowSatisfactory;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 741:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acSpilageTestSatisfactory;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 742:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acVentilationSatisfactory;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 743:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acAirGasPressureSwitchWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 744:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acFlameProvingSafetyDevicesWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 745:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acBurnerLockoutTime;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 746:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acTempAndThermostatsWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 747:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acApplianceServiced;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 748:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acGasBoostersCompressorsWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 749:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acGasInstallationTightnessTestCarriedOut;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 750:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acGasInstallationPipeworkSupported;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 751:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acGasInstallationPipeworkSleevedLabelledPainted;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 752:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acChimneyInstalledwithStandards;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 753:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.acFanFlueInterlockWorking;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 760:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.workCarriedOut;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 761:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.remedialWorkRequired;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 762:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.warningNoticeNumber;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 763:
                {
                    if (applianceInspectionsArray.count > 3) {
                        PlantComServiceApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.warningNoticeIssued;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 801:
                {
                    
                        NSString *str = cert.ventilationNaturalLowLevel;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    break;}
                    
                    
                    
                case 802:
                {
                    
                    NSString *str = cert.ventilationNaturalHighLevel;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 295:
                {
                    NSString *str = cert.customerMobileNumber;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 803:
                {
                    
                    NSString *str = cert.ventilationNaturalGrillesClear;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 804:
                {
                    
                    NSString *str = cert.ventilationMechanicalInlet;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 805:
                {
                    
                    NSString *str = cert.ventilationMechanicalExtract;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 806:
                {
                    
                    NSString *str = cert.ventilationMechanicalInterlock;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 807:
                {
                    
                    NSString *str = cert.ventilationMechanicalClear;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                    
                case 901:
                {
                    
                    NSString *str = cert.workCarriedOut;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                
                case 902:
                {
                    
                    NSString *str = cert.remedialWorkRequired;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                  
                case 903:
                {
                    
                    NSString *str = cert.warningNoticeIssued;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                    
                case 904:
                {
                    
                    NSString *str = cert.warningNoticeNumber;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                 
                case 905:
                {
                    NSString *str = cert.responsiblePersonNotified;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

             
                case 906:
                {
                    NSString *str = cert.responsiblePersonName;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                    
                    
                    
                case 907:
                {
                    NSString *str = cert.customerSignoffName;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                    
                    
                case 908:
                {
                    NSString *str = cert.customerPosition;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                    
                    
                    
                case 909:
                {
                   
                    NSString *str;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    // [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    [dateFormatter setDateFormat:@"d MMMM yyyy"];
                    
                    str = [dateFormatter stringFromDate:cert.customerSignoffDate];
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;

                }

                case 910:
                {
                    NSString *str = cert.engineerSignoffEngineerIDCardRegNumber;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                    
                case 911:
                {
                    
                    NSString *str;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    // [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    [dateFormatter setDateFormat:@"d MMMM yyyy"];
                    
                    str = [dateFormatter stringFromDate:cert.engineerSignoffDate];
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;
                    
                }
                    
                    
                case 296:
                {
                    NSString *str = cert.siteMobileNumber;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 297:
                {
                    NSString *str = cert.engineerSignoffMobileNumber;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                    
                    
                    
                case 306:
                {
                    NSString *str =  cert.engineerSignoffEngineerName;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                    
                    
                case 307:
                {
                    NSString *str =  cert.engineerSignoffEngineerIDCardRegNumber;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                    
                    
                    
                case 308:
                {
                    
                    
                    NSString *str;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    // [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    [dateFormatter setDateFormat:@"d MMMM yyyy"];
                    
                    str = [dateFormatter stringFromDate:cert.date];
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;
                }
                    
                    
                case 309:
                {
                    NSString *str = cert.customerPosition;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 310:
                {
                    NSString *str = [NSString stringWithFormat:@"%i", applianceInspectionsArray.count];
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 311:
                {
                    NSString *str;
                    
                    if ([self shouldUseContinuation]) {
                        str = @"1 of 2";
                    }
                    else
                    {
                        str = @"1 of 1";
                    }
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 333:
                {
                    NSString *str;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //   [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    [dateFormatter setDateFormat:@"d MMMM yyyy"];
                    
                    
                    NSDateComponents *components = [[NSDateComponents alloc] init];
                    components.month = 12;
                    NSDate *oneMonthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:cert.date options:0];
                    
                    str = [dateFormatter stringFromDate:oneMonthFromNow];
                    
                    if (str.length > 0) {
                        label.text = [NSString stringWithFormat:@"NEXT SAFETY CHECK DUE BEFORE %@", str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                    
                    
                    
                case 1101:
                {
                    if (![self shouldUseContinuation]) {
                        label.text = @"";
                    }
                }
                    
                default:
                    
                    break;
            }
            
            
            if ([label.text isEqualToString:@"Not Set"]) {
                label.text = @"";
            }
            
            
            [self drawText:label.text inFrame:label.frame withUILabel:label];
        }
    }
    
}


+(void)drawLogo:(NSString*)reportLayoutName
{
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:reportLayoutName owner:nil options:nil];
    UIView* mainView = [objects objectAtIndex:0];
    
    for (UIView* view in [mainView subviews]) {
        if([view isKindOfClass:[UIImageView class]])
        {
            switch(view.tag)
            {
                case 1001:{
                    UIImage *image = [LACFileHandler getImageFromDocumentsDirectory:cert.customerSignatureFilename subFolderName:@"signatures"];
                    [self drawImage:image inRect:view.frame];
                    break;}
                case 1002:{
                    
                    UIImage *image;
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
                    NSString *dataPath = [documentsPath stringByAppendingPathComponent:@"system"];
                    NSString *filePath = [dataPath stringByAppendingPathComponent:@"logo.png"]; //Add the file name
                    image = [[UIImage alloc] initWithContentsOfFile:filePath];
                    
                    [self drawImage:image inRect:view.frame];
                    break;
                }
                case 1003:{
                    UIImage *image = [LACFileHandler getImageFromDocumentsDirectory:cert.engineerSignatureFilename subFolderName:@"system"];
                    
                    NSLog(@"engineerFilename = %@", cert.engineerSignatureFilename);
                    
                    [self drawImage:image inRect:view.frame];
                    break;
                }
                    
                case 1004:{
                    UIImage *image = [UIImage imageNamed:@"gas-safe-logo-white-bg.gif"];
                    
                    [self drawImage:image inRect:view.frame];
                    break;
                }
                    
            }
        }
    }
}





+(void)drawTableAt:(CGPoint)origin
     withRowHeight:(int)rowHeight
    andColumnWidth:(int)columnWidth
       andRowCount:(int)numberOfRows
    andColumnCount:(int)numberOfColumns

{
    
    for (int i = 0; i <= numberOfRows; i++) {
        int newOrigin = origin.y + (rowHeight*i);
        
        CGPoint from = CGPointMake(origin.x, newOrigin);
        CGPoint to = CGPointMake(origin.x + (numberOfColumns*columnWidth), newOrigin);
        
        [self drawLineFromPoint:from toPoint:to];
    }
    
    for (int i = 0; i <= numberOfColumns; i++) {
        
        int newOrigin = origin.x + (columnWidth*i);
        
        CGPoint from = CGPointMake(newOrigin, origin.y);
        CGPoint to = CGPointMake(newOrigin, origin.y +(numberOfRows*rowHeight));
        
        [self drawLineFromPoint:from toPoint:to];
    }
}



@end


