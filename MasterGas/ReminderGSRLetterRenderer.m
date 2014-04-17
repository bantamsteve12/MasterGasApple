//
//  ReminderGSRLetterRenderer.m
//  MasterGas
//
//  Created by Stephen Lalor on 20/09/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "ReminderGSRLetterRenderer.h"
#import "CoreText/CoreText.h"
#import "UIColor+Additions.h"
#import "Certificate.h"
#import "ApplianceInspection.h"

@implementation ReminderGSRLetterRenderer

Certificate *cert;
Company *company;

NSArray *applianceInspectionsArray;

+(void)drawPDF:(NSString*)fileName withCertificate:(Certificate *)certificate withInspection:(NSArray *)applianceInspections withCertificateReportLayoutName:(NSString *)reportLayoutName withCompanyRecord:(Company *)companyRecord
{
    applianceInspectionsArray = applianceInspections;
    cert = certificate;
    company = companyRecord;
    
     // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
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
    else if(label.tag == 2)
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
           backgroundColor   = [UIColor clearColor];
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
    else if(label.tag == 2)
    {
        textColor = [UIColor blackColor];
        color = textColor.CGColor;
        theAlignment = kCTCenterTextAlignment;
        font = CTFontCreateWithName((CFStringRef) @"System", 10.0, NULL);
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
   
    else if(label.tag == 333)
    {
        textColor = [UIColor whiteColor];
        color = textColor.CGColor;
        font = CTFontCreateWithName((CFStringRef) @"System",14.0, NULL);
        theAlignment = kCTCenterTextAlignment;
        
    }
    else if(label.tag == 40 ||
            label.tag == 41 ||
            label.tag == 42 ||
            label.tag == 43 ||
            label.tag == 44 ||
            label.tag == 45 ||
            label.tag == 46)
    {
        textColor = [UIColor blackColor];
        color = textColor.CGColor;
        font = CTFontCreateWithName((CFStringRef) @"System",10.0, NULL);
        theAlignment = kCTLeftTextAlignment;
    }
    
    
    else if(label.tag == 98 || label.tag == 47 || label.tag == 49)
    {
        textColor = [UIColor blackColor];
        color = textColor.CGColor;
        font = CTFontCreateWithName((CFStringRef) @"System",8.0, NULL);
        theAlignment = kCTLeftTextAlignment;
    }
    
    else
    {
        textColor = [UIColor blackColor];
        color = textColor.CGColor;
        font = CTFontCreateWithName((CFStringRef) @"System",12.0, NULL);
        theAlignment = kCTLeftTextAlignment;

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
              
                    
                case 21:{
                    NSString *str = cert.siteAddressName;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
               
                case 22:{
                    NSString *str = cert.siteAddressLine1;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                
                case 23:{
                    NSString *str = cert.siteAddressLine2;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                
                case 24:{
                    NSString *str = cert.siteAddressLine3;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                
                case 25:{
                    NSString *str = cert.siteAddressPostcode;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
              
                case 40:{
                    NSString *str = company.companyName;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
               
                case 41:{
                    NSString *str = company.companyAddressLine1;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 42:{
                    NSString *str = company.companyAddressLine2;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 43:{
                    NSString *str = company.companyAddressLine3;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 44:{
                    NSString *str = company.companyPostcode;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 45:{
                    NSString *str = company.companyTelNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 46:{
                    NSString *str = company.companyMobileNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 47:{
                    NSString *str = company.companyCompaniesHouseRegNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 48:{
                
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //   [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    [dateFormatter setDateFormat:@"d MMMM yyyy"];

                    label.text = [dateFormatter stringFromDate:[NSDate date]];
                    
                    break;}

                case 49:{
                    NSString *str = company.companyGSRNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 50:{
                    NSString *str = company.companyEmailAddress;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    

                    
                case 51:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = [NSString stringWithFormat:@"%@ - %@",applianceInspection.applianceMake, applianceInspection.applianceModel];
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 52:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 53:
                {
                    if (applianceInspectionsArray.count > 0) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                         NSString *str = applianceInspection.applianceType;
                        
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
                       
                        NSString *str;
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        //   [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                        [dateFormatter setDateFormat:@"d MM yyyy"];
                        
                        NSDateComponents *components = [[NSDateComponents alloc] init];
                        components.month = 12;
                        NSDate *oneMonthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:cert.date options:0];
                        
                        str = [dateFormatter stringFromDate:oneMonthFromNow];
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                        break;
                        
                    }
                }
                    
                case 55:
                {
                    if (applianceInspectionsArray.count > 1) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = [NSString stringWithFormat:@"%@ - %@",applianceInspection.applianceMake, applianceInspection.applianceModel];
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 56:
                {
                    if (applianceInspectionsArray.count > 1) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 57:
                {
                    if (applianceInspectionsArray.count > 1) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:1];
                        
                        NSString *str = applianceInspection.applianceType;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 58:
                {
                    if (applianceInspectionsArray.count > 1) {
                        
                        NSString *str;
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        //   [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                        [dateFormatter setDateFormat:@"d MM yyyy"];
                        
                        NSDateComponents *components = [[NSDateComponents alloc] init];
                        components.month = 12;
                        NSDate *oneMonthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:cert.date options:0];
                        
                        str = [dateFormatter stringFromDate:oneMonthFromNow];
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                        break;
                        
                    }
                }
                    
                case 59:
                {
                    if (applianceInspectionsArray.count > 2) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = [NSString stringWithFormat:@"%@ - %@",applianceInspection.applianceMake, applianceInspection.applianceModel];
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 60:
                {
                    if (applianceInspectionsArray.count > 2) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 61:
                {
                    if (applianceInspectionsArray.count > 2) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:2];
                        
                        NSString *str = applianceInspection.applianceType;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 62:
                {
                    if (applianceInspectionsArray.count > 2) {
                        
                        NSString *str;
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        //   [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                        [dateFormatter setDateFormat:@"d MM yyyy"];
                        
                        NSDateComponents *components = [[NSDateComponents alloc] init];
                        components.month = 12;
                        NSDate *oneMonthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:cert.date options:0];
                        
                        str = [dateFormatter stringFromDate:oneMonthFromNow];
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                        break;
                        
                    }
                }
                    
                case 63:
                {
                    if (applianceInspectionsArray.count > 3) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = [NSString stringWithFormat:@"%@ - %@",applianceInspection.applianceMake, applianceInspection.applianceModel];
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 64:
                {
                    if (applianceInspectionsArray.count > 3) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:3];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 65:
                {
                    if (applianceInspectionsArray.count > 3) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.applianceType;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                
                case 66:
                {
                    if (applianceInspectionsArray.count > 3) {
                        
                        NSString *str;
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        //   [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                        [dateFormatter setDateFormat:@"d MM yyyy"];
                        
                        NSDateComponents *components = [[NSDateComponents alloc] init];
                        components.month = 12;
                        NSDate *oneMonthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:cert.date options:0];
                        
                        str = [dateFormatter stringFromDate:oneMonthFromNow];
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                        break;
                        
                    }
                }
                
                case 67:
                {
                    if (applianceInspectionsArray.count > 4) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:4];
                        
                        NSString *str = [NSString stringWithFormat:@"%@ - %@",applianceInspection.applianceMake, applianceInspection.applianceModel];
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 68:
                {
                    if (applianceInspectionsArray.count > 4) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 69:
                {
                    if (applianceInspectionsArray.count > 4) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.applianceType;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
                    
                case 70:
                {
                    if (applianceInspectionsArray.count > 4) {
                        
                        NSString *str;
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        //   [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                        [dateFormatter setDateFormat:@"d MM yyyy"];
                        
                        NSDateComponents *components = [[NSDateComponents alloc] init];
                        components.month = 12;
                        NSDate *oneMonthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:cert.date options:0];
                        
                        str = [dateFormatter stringFromDate:oneMonthFromNow];
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                        break;
                        
                    }
                }
                    
                case 71:
                {
                    if (applianceInspectionsArray.count > 5) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:5];
                        
                        NSString *str = [NSString stringWithFormat:@"%@ - %@",applianceInspection.applianceMake, applianceInspection.applianceModel];
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 72:
                {
                    if (applianceInspectionsArray.count > 5) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:0];
                        
                        NSString *str = applianceInspection.location;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                    }
                    break;}
                    
                case 73:
                {
                    if (applianceInspectionsArray.count > 5) {
                        ApplianceInspection *applianceInspection = [applianceInspectionsArray objectAtIndex:5];
                        
                        NSString *str = applianceInspection.applianceType;
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }}
                    break;}
               
                case 74:
                {
                    if (applianceInspectionsArray.count > 5) {
                        
                        NSString *str;
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        //   [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                        [dateFormatter setDateFormat:@"d MM yyyy"];
                        
                        NSDateComponents *components = [[NSDateComponents alloc] init];
                        components.month = 12;
                        NSDate *oneMonthFromNow = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:cert.date options:0];
                        
                        str = [dateFormatter stringFromDate:oneMonthFromNow];
                        
                        if (str.length > 0) {
                            label.text = str;
                        }
                        else {
                            label.text = @"";
                        }
                        break;
                        
                    }
                }
                    
                case 75:
                {
                    break;
                }
                    
                case 80:
                {
                    NSString *str;
                    
                    str = company.companyName;
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;
                }
                    
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
                    
                  //  CGRect *rect = CGRectMake(view.frame.origin.x, view.frame.origin.y, image.size.width, image.size.height);
                
                    
                    
                  //  [self drawImage:image inRect:CGRectMake(view.frame.origin.x, view.frame.origin.y, image.size.width, image.size.height)];

                    
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


