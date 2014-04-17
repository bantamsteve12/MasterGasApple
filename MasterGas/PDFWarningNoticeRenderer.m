//
//  PDFWarningNoticeRenderer.m
//  MasterGas
//
//  Created by Stephen Lalor on 23/06/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "PDFWarningNoticeRenderer.h"
#import "CoreText/CoreText.h"
#import "UIColor+Additions.h"
#import "WarningNotice.h"


@implementation PDFWarningNoticeRenderer

WarningNotice *cert;



+(void)drawPDF:(NSString*)fileName withWarningNotice:(WarningNotice *)warningNotice withCertificateReportLayoutName:(NSString *)reportLayoutName
{
    
    cert = warningNotice;
    
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
    else if(label.tag == 9)
    {
        backgroundColor = [UIColor colorWithR:235 G:235 B:235 A:1];
     
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
    else if(label.tag == 501 || label.tag == 601 || label.tag == 706)
    {
        textColor = [UIColor redColor];
        color = textColor.CGColor;
        font = CTFontCreateWithName((CFStringRef) @"System",8.0, NULL);
        theAlignment = kCTLeftTextAlignment;
        
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
                    NSString *str = cert.warningNoticeNumber;
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
                    
                
               case 33:
                {
                    NSString *str = cert.customerNotPresent;
                  
                    NSLog(@"customerNotPresent = %@", cert.customerNotPresent);
                    
                    if (str.length > 0) {
                        
                        if ([str isEqualToString:@"Not Set"]) {
                          label.text = @"n/a";
                        }
                        else
                        {
                            label.text = str;
                        }
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
                    
                    
                                   
                    
                    
                case 333:
                {
                    NSString *str;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                   // [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
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
                    
                    
                    // Appliance Details Section
                    
                case 401:
                {
                    
                  NSString *str = cert.gasEscape;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    } 
                    break;}
                    
                                      
                case 404:
                {
                    
                    NSString *str = cert.applianceLocation;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 405:
                {
                    
                    NSString *str = cert.applianceType;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 406:
                {
                    
                    NSString *str = cert.applianceMake;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 407:
                {
                    
                    NSString *str = cert.applianceModel;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                                 
                case 410:
                {
                    
                    NSString *str = cert.applianceSerialNumber;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                 
                case 501:
                {
                    
                    NSString *str = cert.immediatelyDangerousStatement;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 502:
                {
                    
                    NSLog(@"cert.warningLabelStatement = %@", cert.warningLabelStatement);
                    
                    
                    if ([cert.warningLabelStatement isEqualToString:@"Yes"]) {
                        
                        NSString *str = @"TRUE";
                    
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    else if ([cert.warningLabelStatement isEqualToString:@"No"]) {
                        label.text = @"-";
                    }

                    else if ([cert.warningLabelStatement isEqualToString:@"N/A"]) {
                        label.text = @"N/A";
                    }
                    else
                    {
                        label.text = @"";
                    }
                    break;}
                    
                case 503:
                {
                    if ([cert.warningLabelStatement isEqualToString:@"No"]) {
                        
                        NSString *str = @"TRUE";
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    else if ([cert.warningLabelStatement isEqualToString:@"Yes"]) {
                        label.text = @"-";
                    }
                    else if ([cert.warningLabelStatement isEqualToString:@"N/A"]) {
                        label.text = @"N/A";
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                  
                case 601:
                {
                    
                    NSString *str = cert.atRiskStatement;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                case 602:
                {
                    
                    NSString *str = cert.warningLabelAttached;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                case 701:
                {
                    
                    if (cert.notToCurrentStandardsStatement.length > 1) {
                        
                        NSString *str = cert.applianceLocation;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
 
                case 702:
                {
                    
                    if (cert.notToCurrentStandardsStatement.length > 1) {
                        
                        NSString *str = cert.applianceType;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 703:
                {
                    
                    if (cert.notToCurrentStandardsStatement.length > 1) {
                        
                        NSString *str = cert.applianceMake;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 704:
                {
                    
                    if (cert.notToCurrentStandardsStatement.length > 1) {
                        
                        NSString *str = cert.applianceModel;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 705:
                {
                    
                    if (cert.notToCurrentStandardsStatement.length > 1) {
                        
                        NSString *str = cert.applianceSerialNumber;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 706:
                {
                    
                    if (cert.notToCurrentStandardsStatement.length > 1) {
                        
                        NSString *str = cert.notToCurrentStandardsStatement;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 801:
                {
                    
                    NSString *str = cert.customerPosition;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 802:
                {
                    
                    NSString *str;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                  //  [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    [dateFormatter setDateFormat:@"d MMMM yyyy"];
                    
                    str = [dateFormatter stringFromDate:cert.customerSignoffDate];
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 803:
                {
                    
                    NSString *str =  cert.engineerSignoffEngineerName;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 804:
                {
                    
                    NSString *str =  cert.engineerSignoffEngineerIDCardRegNumber;
                    
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 805:
                {
                    
                    NSString *str;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //  [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    [dateFormatter setDateFormat:@"d MMMM yyyy"];
                    
                    str = [dateFormatter stringFromDate:cert.engineerSignoffDate];
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 806:
                {
                    
                    NSString *str =  cert.customerSignoffName;
                    
                    if (str.length > 0) {
                        label.text = str;
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
               
                    
                    NSLog(@"engineer signature: %@", cert.engineerSignatureFilename);
                    
                    UIImage *image = [LACFileHandler getImageFromDocumentsDirectory:cert.engineerSignatureFilename subFolderName:@"system"];
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
