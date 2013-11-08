//
//  PDFRenderer.m
//  MasterGas
//
//  Created by Stephen Lalor on 03/01/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "PDFRenderer.h"
#import "CoreText/CoreText.h"
#import "UIColor+Additions.h"
#import "Certificate.h"
#import "ApplianceInspection.h"

@implementation PDFRenderer


Certificate *cert;

//NSMutableArray *applianceInspectionsArray;
NSArray *applianceInspectionsArray;


//ApplianceInspection *_applianceInspection;
//+(void)drawPDF:(NSString*)fileName withCertificate:(Certificate *)certificate withInspection:(NSMutableArray *)applianceInspections withCertificateReportLayoutName:(NSString *)reportLayoutName

+(void)drawPDF:(NSString*)fileName withCertificate:(Certificate *)certificate withInspection:(NSArray *)applianceInspections withCertificateReportLayoutName:(NSString *)reportLayoutName
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

 
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}


-(void)setup
{
    
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
    else if(label.tag == 8)
    {
        backgroundColor   = [UIColor colorWithR:54 G:100 B:139 A:1];

    }
    else if (label.tag == 333) {
        backgroundColor   = [UIColor colorWithR:54 G:100 B:139 A:1];
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
    
    //CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)stringToDraw);
    

   // CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    
  
    
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
        
            
            NSLog(@"cert.customerAddressName = %@", cert.customerAddressName);
            
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
                case 33:{
                    NSString *str = cert.finalCheckGasInstallationPipework;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 34:{
                    NSString *str = cert.finalCheckECV;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 35:{
                    NSString *str = cert.finalCheckGasTightness;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                case 36:{
                    NSString *str = cert.finalCheckEquipotentialBonding;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
               
                    
                case 40:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                    
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.location;
                    
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 41:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                    
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.applianceType;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    }
                    break;}

                case 42:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.applianceMake;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                case 43:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.applianceModel;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                               
                case 44:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.flueType;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 45:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.landlordsAppliance;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 46:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.applianceInspected;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                                   
                    
                    
                case 50:
                {
                    
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
               
                    NSString *str = @"";
                        
                    NSString *operatingPressure = [NSString stringWithFormat:@"%@ mbar", applianceInspection.operatingPressure];
                    NSString *heatInput = [NSString stringWithFormat:@"%@ kW/h", applianceInspection.heatInput];
                        
                    
                        if ((applianceInspection.operatingPressure.length > 0) && (applianceInspection.heatInput.length > 0)) {
                            str = [NSString stringWithFormat:@"%@/%@", operatingPressure, heatInput];
                        }
                        else if (applianceInspection.operatingPressure.length > 0)
                        {
                            str = operatingPressure;
                        }
                        else if (applianceInspection.heatInput.length > 0)
                        {
                            str = heatInput;
                        }
                        else
                        {
                            str = @"";
                        }
                        
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 51:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.safetyDeviceInCorrectOperation;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                case 52:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                    
                    
                    NSString *str = applianceInspection.ventilationProvision;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                case 53:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.visualConditionOfFlueSatisfactory;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                case 54:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.fluePerformanceTests;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 55:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.applianceServiced;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 56:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.applianceSafeToUse;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                case 57:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.faultDetails;
                    
                    NSLog(@"fault = %@", applianceInspection.faultDetails);
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 58:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.remedialActionTaken;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 59:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.warningNoticeNumber;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}

                    
                case 60:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.combustion1stCOReading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}

                    
                    
                case 61:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.combustion1stCO2Reading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}

                    
                    
                    
                case 62:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.combustion1stRatioReading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}

                    
                    
                    
                case 63:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.combustion2ndCOReading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}

                    
                    
                case 64:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.combustion2ndCO2Reading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}

                    
                    
                case 65:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.combustion2ndRatioReading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}

                    
                    
                    
                case 66:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.combustion3rdCOReading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}

                    
                    
                    
                case 67:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                    
                        //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.combustion3rdCO2Reading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}

                    
                    
                case 68:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.combustion3rdRatioReading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}

                    
                    // Start inspection 2
                    
                    
                case 80:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                        }
                    break;
                }
                    
                case 81:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.applianceType;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    }
                    break;}
                    
                case 82:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.applianceMake;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    }
                    break;}
                    
                case 83:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                    
                    ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                    
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.applianceModel;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    }
                    break;}
                    
                    
                case 84:
                {   if (applianceInspectionsArray.count > 1) {
                    
                    ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.flueType;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                }
                    break;}
                    
                case 85:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.landlordsAppliance;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 86:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.applianceInspected;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 87:
                {
                    // to sort out operating pressure
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                        NSString *str = applianceInspection.operatingPressure;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 88:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                    ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                    
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.safetyDeviceInCorrectOperation;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                case 89:
                {
                    if (applianceInspectionsArray.count > 1) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        
                        NSString *str = applianceInspection.ventilationProvision;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
            
                case 90:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];                    NSString *str = applianceInspection.visualConditionOfFlueSatisfactory;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                case 91:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.fluePerformanceTests;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 92:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                    
                    ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                    
                    //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                    NSString *str = applianceInspection.applianceServiced;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 93:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.applianceSafeToUse;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                case 94:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.faultDetails;
                    
                    NSLog(@"fault = %@", applianceInspection.faultDetails);
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 95:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.remedialActionTaken;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 96:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.warningNoticeNumber;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                case 97:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];                    NSString *str = applianceInspection.combustion1stCOReading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                    
                case 98:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.combustion1stCO2Reading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                    
                    
                case 99:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.combustion1stRatioReading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                    
                    
                case 100:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.combustion2ndCOReading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                    
                case 101:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.combustion2ndCO2Reading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                    
                case 102:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];                    NSString *str = applianceInspection.combustion2ndRatioReading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                    
                    
                case 103:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.combustion3rdCOReading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                    
                    
                case 104:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.combustion3rdCO2Reading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                    
                case 105:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:1];
                    NSString *str = applianceInspection.combustion3rdRatioReading;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    

                    // End inspection 2
                    
                    
                    // Start inspection 3
                    
                case 110:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;
                }
                    
                case 111:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.applianceType;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 112:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.applianceMake;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 113:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
        
                    NSString *str = applianceInspection.applianceModel;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                case 114:
                {    if (applianceInspectionsArray.count > 2) {
                    
                    ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                    NSString *str = applianceInspection.flueType;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                }
                    break;}
                    
                case 115:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                    NSString *str = applianceInspection.landlordsAppliance;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 116:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.applianceInspected;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 117:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.operatingPressure;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 118:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                    NSString *str = applianceInspection.safetyDeviceInCorrectOperation;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                    
                case 119:
                {
                    
                    if (applianceInspectionsArray.count > 2) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        
                        NSString *str = applianceInspection.ventilationProvision;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 120:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.visualConditionOfFlueSatisfactory;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 121:
                { if (applianceInspectionsArray.count > 2) {
                    
                    ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                    
                        NSString *str = applianceInspection.fluePerformanceTests;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 122:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        
                    NSString *str = applianceInspection.applianceServiced;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 123:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.applianceSafeToUse;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                case 124:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.faultDetails;
                        
                        NSLog(@"fault = %@", applianceInspection.faultDetails);
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 125:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.remedialActionTaken;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 126:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.warningNoticeNumber;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 127:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.combustion1stCOReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 128:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.combustion1stCO2Reading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 129:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.combustion1stRatioReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 130:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.combustion2ndCOReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 131:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.combustion2ndCO2Reading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 132:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.combustion2ndRatioReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 133:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.combustion3rdCOReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 134:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.combustion3rdCO2Reading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 135:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:2];
                        NSString *str = applianceInspection.combustion3rdRatioReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    // end appliance inspection 3
                    
                    // start appliance inspection 4
                case 140:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;
                }
                    
                case 141:
                {   if (applianceInspectionsArray.count > 3) {
                    
                    ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                    
                    NSString *str = applianceInspection.applianceType;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 142:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                        NSString *str = applianceInspection.applianceMake;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 143:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
      
                        NSString *str = applianceInspection.applianceModel;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 144:
                {    if (applianceInspectionsArray.count > 3) {
                    
                    ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                    
                    NSString *str = applianceInspection.flueType;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                }
                    break;}
                    
                case 145:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.landlordsAppliance;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 146:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.applianceInspected;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 147:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.operatingPressure;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 148:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.safetyDeviceInCorrectOperation;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 149:
                {
                    
                    if (applianceInspectionsArray.count > 3) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        
                        NSString *str = applianceInspection.ventilationProvision;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 150:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.visualConditionOfFlueSatisfactory;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 151:
                {
                    if (applianceInspectionsArray.count > 3) {
                    
                    ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                    
                        NSString *str = applianceInspection.fluePerformanceTests;
                        
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }}
                    break;}
                    
                case 152:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
      
                        NSString *str = applianceInspection.applianceServiced;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 153:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.applianceSafeToUse;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                case 154:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.faultDetails;
                        
                        NSLog(@"fault = %@", applianceInspection.faultDetails);
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 155:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.remedialActionTaken;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 156:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.warningNoticeNumber;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 157:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.combustion1stCOReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 158:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.combustion1stCO2Reading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 159:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.combustion1stRatioReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 160:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.combustion2ndCOReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 161:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.combustion2ndCO2Reading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 162:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.combustion2ndRatioReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 163:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.combustion3rdCOReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 164:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.combustion3rdCO2Reading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 165:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:3];
                        
                        NSString *str = applianceInspection.combustion3rdRatioReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
// end of appliance inspection 4
                    
                    // start appliance inspection 5
                    
                case 170:
                {
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;
                }
                    
                case 171:
                {
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                    
                    NSString *str = applianceInspection.applianceType;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                }
                    break;}
                    
                case 172:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        //NSString *str = [applianceInspectionsArray objectAtIndex:0];
                        NSString *str = applianceInspection.applianceMake;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 173:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.applianceModel;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 174:
                {
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                    
                    NSString *str = applianceInspection.flueType;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                }
                    break;}
                    
                case 175:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.landlordsAppliance;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 176:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.applianceInspected;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 177:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.operatingPressure;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 178:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.safetyDeviceInCorrectOperation;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 179:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:4];
                        
                        
                        NSString *str = applianceInspection.ventilationProvision;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 180:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.visualConditionOfFlueSatisfactory;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 181:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.fluePerformanceTests;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 182:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.applianceServiced;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 183:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.applianceSafeToUse;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 184:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.faultDetails;
                        
                        NSLog(@"fault = %@", applianceInspection.faultDetails);
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 185:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.remedialActionTaken;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 186:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.warningNoticeNumber;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 187:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.combustion1stCOReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 188:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.combustion1stCO2Reading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 189:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.combustion1stRatioReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
              
                    
                case 190:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.combustion2ndCOReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 191:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.combustion2ndCO2Reading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 192:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.combustion2ndRatioReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 193:
                {
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.combustion3rdCOReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 194:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.combustion3rdCO2Reading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 195:
                {
                    
                    if (applianceInspectionsArray.count > 4) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:4];
                        
                        NSString *str = applianceInspection.combustion3rdRatioReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    // end appliance inspection 5
                    
                    // start appliance inspecton 6
                    
                case 200:
                {
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;
                }
                    
                case 201:
                {
                    if (applianceInspectionsArray.count > 5) {
                    
                    ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                    
                        NSString *str = applianceInspection.applianceType;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 202:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.applianceMake;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 203:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.applianceModel;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 204:
                {
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.flueType;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 205:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.landlordsAppliance;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 206:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.applianceInspected;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 207:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.operatingPressure;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 208:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.safetyDeviceInCorrectOperation;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 209:
                {
                    if (applianceInspectionsArray.count > 5) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:5];
                        
                        
                        NSString *str = applianceInspection.ventilationProvision;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 210:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.visualConditionOfFlueSatisfactory;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 211:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.fluePerformanceTests;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 212:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.applianceServiced;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 213:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.applianceSafeToUse;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 214:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.faultDetails;
                        
                        NSLog(@"fault = %@", applianceInspection.faultDetails);
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 215:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.remedialActionTaken;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 216:
                {
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.warningNoticeNumber;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 217:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.combustion1stCOReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 218:
                {
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.combustion1stCO2Reading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 219:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.combustion1stRatioReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                case 220:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.combustion2ndCOReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 221:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.combustion2ndCO2Reading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 222:
                {
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.combustion2ndRatioReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 223:
                {
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.combustion3rdCOReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                    
                case 224:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.combustion3rdCO2Reading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                    
                    
                case 225:
                {
                    
                    if (applianceInspectionsArray.count > 5) {
                        
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray   objectAtIndex:5];
                        
                        NSString *str = applianceInspection.combustion3rdRatioReading;
                        
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}

                    
                    
                    // end appliance inspection 6
                    
                    
                    
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
                    
                    
                case 298:
                {
                    NSString *str = cert.finalCheckGasTightnessInitialValue;
                    
                    
                    if (str.length > 0) {
                        label.text = [NSString stringWithFormat:@"%@ mbar",str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    

                    
                case 299:
                {
                    NSString *str = cert.finalCheckGasTightnessFinalValue;
                    
                    if (str.length > 0) {
                        label.text = [NSString stringWithFormat:@"%@ mbar",str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 300:
                {
                    NSString *str = cert.finalCheckGasInstallationPipework;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 301:
                {
                    NSString *str = cert.finalCheckECV;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 302:
                {
                   
                    NSString *str = cert.finalCheckGasTightness;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 303:
                {
                    NSString *str = cert.finalCheckEquipotentialBonding;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 304:
                {
                    NSString *str = @""; //  cert.finalCheckEquipotentialBonding;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                    
                    
                case 305:
                {
                    NSString *str = @""; //  cert.finalCheckEquipotentialBonding;
                    
                    
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
                    
                    if (applianceInspectionsArray.count <= 6) {
                        str = @"1 of 1";
                    }
                    else if (applianceInspectionsArray.count > 6 && applianceInspectionsArray.count <= 18)
                    {
                         str = @"1 of 2";
                    }
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 312:
                {
                    NSString *str =  cert.cylinderFinalConnection;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;
                }
                    
                case 313:
                {
                    NSString *str =  cert.lpgRegulatorOperatingPressure;
                    
                    if (str.length > 0) {
                        label.text = [NSString stringWithFormat:@"%@ mbar", str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;
                }
                case 314:
                {
                    NSString *str =  cert.lpgRegulatorLockupPressure;
                    
                    if (str.length > 0) {
                        label.text = [NSString stringWithFormat:@"%@ mbar", str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;
                }
                    
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
                                
                default:
                    
                break;
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
                     UIImage *image = [LACFileHandler getImageFromDocumentsDirectory:@"logo.png" subFolderName:@"system"];
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

/* NOT USED IN THIS INSTANCE

+(void)drawTableDataAt:(CGPoint)origin
         withRowHeight:(int)rowHeight
        andColumnWidth:(int)columnWidth
           andRowCount:(int)numberOfRows
        andColumnCount:(int)numberOfColumns
{
    int padding = 10;
    
    NSArray* headers = [NSArray arrayWithObjects:@"Quantity", @"Description", @"Unit price", @"Total", nil];
    NSArray* invoiceInfo1 = [NSArray arrayWithObjects:@"1", @"Development", @"$1000", @"$1000", nil];
    NSArray* invoiceInfo2 = [NSArray arrayWithObjects:@"1", @"Development", @"$1000", @"$1000", nil];
    NSArray* invoiceInfo3 = [NSArray arrayWithObjects:@"1", @"Development", @"$1000", @"$1000", nil];
    NSArray* invoiceInfo4 = [NSArray arrayWithObjects:@"1", @"Development", @"$1000", @"$1000", nil];
    
    NSArray* allInfo = [NSArray arrayWithObjects:headers, invoiceInfo1, invoiceInfo2, invoiceInfo3, invoiceInfo4, nil];
    
    for(int i = 0; i < [allInfo count]; i++)
    {
        NSArray* infoToDraw = [allInfo objectAtIndex:i];
        
        for (int j = 0; j < numberOfColumns; j++)
        {
            
            int newOriginX = origin.x + (j*columnWidth);
            int newOriginY = origin.y + ((i+1)*rowHeight);
            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, columnWidth, rowHeight);
            
            
            [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame];
        }
    }
} */
 
 
 @end


