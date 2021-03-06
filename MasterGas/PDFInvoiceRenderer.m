//
//  PDFInvoiceRenderer.m
//  MasterGas
//
//  Created by Stephen Lalor on 26/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "PDFInvoiceRenderer.h"
#import "CoreText/CoreText.h"
#import "UIColor+Additions.h"
#import "NSString+Additions.h"
#import "Company.h"
#import "LACHelperMethods.h"


@implementation PDFInvoiceRenderer

@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize invoiceItems;

Invoice *inv;
Company *company;

NSMutableArray *invoiceItemsArray;


+(void)drawPDF:(NSString*)fileName withInvoice:(Invoice *)invoice withInvoiceItems:(NSMutableArray *)invoiceItems withCompanyRecord:(Company *)companyRecord;
{
    
    invoiceItemsArray = invoiceItems;
    inv = invoice;
    company = companyRecord;
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    [self drawLabels];
    [self drawLogo];
    
    
    int xOrigin = 9;
    int yOrigin = 195;
    
    int rowHeight = 13;
   
    int columnWidth = 120;
    
    int numberOfRows = 4;
   
    int numberOfColumns = 5;
    
    if (companyRecord.companyVATNumber.length > 0) {
         numberOfColumns = 6;
        [self drawTableDataAt:CGPointMake(xOrigin, yOrigin) withRowHeight:rowHeight andColumnWidth:columnWidth andRowCount:numberOfRows andColumnCount:numberOfColumns];
    }
    else
    {
        numberOfColumns = 5;
        
        [self drawNonVATTableDataAt:CGPointMake(xOrigin, yOrigin) withRowHeight:rowHeight andColumnWidth:columnWidth andRowCount:numberOfRows andColumnCount:numberOfColumns];
    }
  
      
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


// line items
+(void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rectangle = CGRectMake(rect.origin.x-2, rect.origin.y, rect.size.width, rect.size.height);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    
    UIColor *backgroundColor = [UIColor colorWithR:214 G:214 B:214 A:1];
    
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rectangle);
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
        backgroundColor = [UIColor colorWithR:54 G:100 B:139 A:1];
        NSLog(@"background colour called");
    }
    else if(label.tag == 1)
    {
        backgroundColor = [UIColor colorWithR:214 G:214 B:214 A:1];
    }
    else if(label.tag == 2)
    {
        backgroundColor = [UIColor colorWithR:54 G:100 B:139 A:1];
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
    else if(label.tag == 78)
    {
        NSString *str = inv.siteAddressLine1;
        if (str.length < 1) {
            backgroundColor = [UIColor clearColor];
        }
        else
        {
            backgroundColor = [UIColor colorWithR:214 G:214 B:214 A:1];
        }
    }
    else if(label.tag == 79)
    {
        NSString *str = inv.siteAddressLine1;
        if (str.length < 1) {
            backgroundColor = [UIColor clearColor];
        }
        else
        {
            backgroundColor = [UIColor colorWithR:54 G:100 B:139 A:1];
        }
    }

    
    else if (label.tag == 333) {
        backgroundColor   = [UIColor colorWithR:54 G:100 B:139 A:1];
    }
    else if(label.tag >= 71 && label.tag <= 77)
    {
        NSString *str = inv.siteAddressLine1;
        if (str.length < 1) {
             backgroundColor = [UIColor clearColor];
        }
        else
        {
             backgroundColor = [UIColor colorWithR:235 G:235 B:235 A:1];
        }
    }
    else if(label.tag == 880)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *str = [prefs valueForKey:@"invoiceFooterNotes"];
        
        if (str.length > 0) {
            backgroundColor = [UIColor colorWithR:235 G:235 B:235 A:1];
        }
        else
        {
            backgroundColor = [UIColor clearColor];
        }
        
    }
    else
    {
        backgroundColor = [UIColor colorWithR:235 G:235 B:235 A:1];
    }
    
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rectangle);
}

// for line items
+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect
{
    
    UIColor *textColor;
    CGColorRef color;
    CTFontRef font;
    CTTextAlignment theAlignment;
    
    textColor = [UIColor blackColor];
    color = textColor.CGColor;
    theAlignment = kCTLeftTextAlignment;
    font = CTFontCreateWithName((CFStringRef) @"System", 8.0, NULL);

    
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
    
    
    [self drawRect:frameRect];
    
    
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
    else if (label.tag == 2 || label.tag == 79) {
        textColor = [UIColor whiteColor];
        color = textColor.CGColor;
        font = CTFontCreateWithName((CFStringRef) @"System",10.0, NULL);
        theAlignment = kCTCenterTextAlignment;
    }
    else if(label.tag == 78)
    {
        NSString *str = inv.siteAddressLine1;
        if (str.length < 1) {
            textColor = [UIColor whiteColor];
            color = textColor.CGColor;
            theAlignment = kCTLeftTextAlignment;
            font = CTFontCreateWithName((CFStringRef) @"System", 8.0, NULL);
        }
        else
        {
            textColor = [UIColor blackColor];
            color = textColor.CGColor;
            theAlignment = kCTLeftTextAlignment;
            font = CTFontCreateWithName((CFStringRef) @"System", 8.0, NULL);
        }
    }

    else if(label.tag == 4)
    {
        textColor = [UIColor blackColor];
        color = textColor.CGColor;
        theAlignment = kCTRightTextAlignment;
        font = CTFontCreateWithName((CFStringRef) @"System Bold", 30.0, NULL);
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
        font = CTFontCreateWithName((CFStringRef) @"System",15.0, NULL);
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


+(void)drawLabels
{
    
    NSArray* objects;
    
    if (company.companyVATNumber.length > 0) {
         objects = [[NSBundle mainBundle] loadNibNamed:@"Invoice" owner:nil options:nil];
    }
    else
    {
        objects = [[NSBundle mainBundle] loadNibNamed:@"InvoiceNoVat" owner:nil options:nil];
    }
    
   // NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"Invoice" owner:nil options:nil];
    
    UIView* mainView = [objects objectAtIndex:0];
    
    for (UIView* view in [mainView subviews]) {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*)view;
            
           
            switch(label.tag)
            {
               
                case 21:{
                    
                    NSString *str = inv.customerName;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                case 22:{
                    
                    NSString *str = inv.customerAddressLine1;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 23:{
                    
                    NSString *str = inv.customerAddressLine2;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                  
                case 24:{
                    
                    NSString *str = inv.customerAddressLine3;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 25:{
                    
                    NSString *str = inv.customerPostcode;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 26:{
                    
                    NSString *str = inv.customerTelephone;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 27:{
                    
                    NSString *str = inv.customerMobile;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 30:{
                    
                    NSLog(@"invoice number %@", inv.uniqueInvoiceNo);
                    
                    NSString *str = inv.uniqueInvoiceNo;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 31:{
        
                    NSString *str;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    [dateFormatter setDateFormat:@"d MMMM yyyy"];
                    
                    str = [dateFormatter stringFromDate:inv.date];
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;
                }
                
                    
                case 32:{
                    
                    
                    NSString *str;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    [dateFormatter setDateFormat:@"d MMMM yyyy"];
                    
                    str = [dateFormatter stringFromDate:inv.due];
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;
                }
                    
                    
                case 33:{
                    
                    NSString *str = inv.terms;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else if([str isEqualToString:@"Not Set"])
                    {
                        label.text = @"";
                    }
                    else{
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 34:{
                    
                    NSString *str;
                    // TODO: need to sort out page numbers
                    
                    /*
                    if (applianceInspectionsArray.count <= 6) {
                        str = @"1 of 1";
                    }
                    else if (applianceInspectionsArray.count > 6 && applianceInspectionsArray.count <= 18)
                    {
                        str = @"1 of 2";
                    }
                     */
                    
                    str = @"1 of 1";
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
            
                case 35:{
                    
                    NSString *str = inv.comment;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                case 36:{
                    
                    NSString *str = company.companyCompaniesHouseRegNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"n/a";
                    }
                    break;}
                    

                case 37:{
                    NSString *str = company.companyVATNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"n/a";
                    }
                    break;}
                    
                case 38:{
                    NSString *str = inv.reference;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 39:{
                    NSString *str = inv.workOrderReference;
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
                    
                    NSString *str = company.companyEmailAddress;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                    
                case 50:{
                    
                    NSString *str = inv.subtotal;
                    if (str.length > 0) {
                        label.text = [NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 51:{
                    
                    NSLog(@"inv.vat = %@", inv.vat);
                    
                    NSString *str = inv.vat;
                    if (str.length > 0) {
                         label.text = [NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                
                case 52:{
                    
                    NSString *str = inv.total;
                    if (str.length > 0) {
                         label.text = [NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 53:{
                    
                    NSString *str = inv.paid;
                    if (str.length > 0) {
                          label.text = [NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 54:{
                    
                    NSString *str = inv.balanceDue;
                    if (str.length > 0) {
                          label.text = [NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 71:{
                    
                    NSString *str = inv.siteName;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 72:{
                    
                    NSString *str = inv.siteAddressLine1;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 73:{
                    
                    NSString *str = inv.siteAddressLine2;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 74:{
                    
                    NSString *str = inv.siteAddressLine3;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 75:{
                    
                    NSString *str = inv.sitePostcode;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 76:{
                    
                    NSString *str = inv.siteTelephone;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 77:{
                    
                    NSString *str = inv.siteMobile;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 880:{
                    
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    NSString *str = [prefs valueForKey:@"invoiceFooterNotes"];
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
             
            }
            [self drawText:label.text inFrame:label.frame withUILabel:label];
            }
        }

}


+(void)drawLogo
{
    NSArray* objects;
    
    if (company.companyVATNumber.length > 0) {
        objects = [[NSBundle mainBundle] loadNibNamed:@"Invoice" owner:nil options:nil];
    }
    else
    {
        objects = [[NSBundle mainBundle] loadNibNamed:@"InvoiceNoVat" owner:nil options:nil];
    }
   
    UIView* mainView = [objects objectAtIndex:0];
    
    for (UIView* view in [mainView subviews]) {
        if([view isKindOfClass:[UIImageView class]])
        {
            switch(view.tag)
            {
                
                case 1001:{
                    UIImage *image = [LACFileHandler getImageFromDocumentsDirectory:@"logo.png" subFolderName:@"system"];
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

/*
+(void)drawTableDataAt:(CGPoint)origin
         withRowHeight:(int)rowHeight
        andColumnWidth:(int)columnWidth
           andRowCount:(int)numberOfRows
        andColumnCount:(int)numberOfColumns
{
    int padding = 1;
    
    int lastyOriginPosition = origin.y;
    int currentRowHeight;
    

    
    for(int i = 0; i < [invoiceItemsArray count]; i++)
    {
        
        InvoiceItem *invItem = [invoiceItemsArray objectAtIndex:i];
        
        float quantity = [invItem.quantity floatValue];
        float unitPrice = [invItem.unitPrice floatValue];
        float discountRate = [invItem.discountRate floatValue];

        float discountAmount = 0.0;
        
        float discountMultiplier = 1;
        
        float total = quantity * unitPrice;
        
        if (discountRate > 0) {
            discountMultiplier = discountRate / 100;
            discountAmount = (total * discountMultiplier);
        }
        
        NSArray* infoToDraw = [NSArray arrayWithObjects:[NSString checkForNilString:invItem.itemDescription], [NSString checkForNilString:invItem.quantity], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@",[LACHelperMethods getDefaultCurrency],invItem.unitPrice]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%.2f",[LACHelperMethods getDefaultCurrency], discountAmount]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency],invItem.vatAmount]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], invItem.total]], nil];
        
        NSLog(@"item description %@", invItem.itemDescription);
        NSLog(@"item total %@", invItem.total);
        
        
        int calcColumnWidth = 0;
        int newOriginX = origin.x;
        
        
        for (int j = 0; j < numberOfColumns; j++)
        {
            switch (j) {
                case 0:
                    calcColumnWidth = 295;
                    break;
                case 1:
                    calcColumnWidth = 60;
                    break;
                case 2:
                    calcColumnWidth = 60;
                    break;
                case 3:
                    calcColumnWidth = 60;
                    break;
                case 4:
                    calcColumnWidth = 60;
                    break;
                case 5:
                    calcColumnWidth = 60;
                    break;
                default:
                    calcColumnWidth = 10;
                    break;
            }
            
           
            currentRowHeight = rowHeight;
            int newOriginY = lastyOriginPosition;
            
            if ([invItem.itemDescription contains:@"\n"]) {
                NSString *str = invItem.itemDescription;
                NSArray *arr = [str componentsSeparatedByString:@"\n"];
                currentRowHeight = 11 * ([arr count]);
            }

            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, calcColumnWidth, currentRowHeight);
        
    
            [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame];
            
            newOriginX = newOriginX + calcColumnWidth;
            
        }
        
        lastyOriginPosition = lastyOriginPosition + currentRowHeight;
    }
} 
 */

+(void)drawTableDataAt:(CGPoint)origin
         withRowHeight:(int)rowHeight
        andColumnWidth:(int)columnWidth
           andRowCount:(int)numberOfRows
        andColumnCount:(int)numberOfColumns
{
    int padding = 1;
    
    int lastyOriginPosition = origin.y;
    int currentRowHeight;
    
    
    for(int i = 0; i < [invoiceItemsArray count]; i++)
    {
        
        int additionalRows = 1;
        
        InvoiceItem *invItem = [invoiceItemsArray objectAtIndex:i];
        
        float quantity = [invItem.quantity floatValue];
        float unitPrice = [invItem.unitPrice floatValue];
        float discountRate = [invItem.discountRate floatValue];
        float discountAmount = 0.0;
        float discountMultiplier = 1;
        float total = quantity * unitPrice;
        
        if (discountRate > 0) {
            discountMultiplier = discountRate / 100; //(100 - discountRate) / 100;
            discountAmount = (total * discountMultiplier);
        }
        
        NSArray* infoToDraw = [NSArray arrayWithObjects:[NSString checkForNilString:invItem.itemDescription], [NSString checkForNilString:invItem.quantity], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@",[LACHelperMethods getDefaultCurrency],invItem.unitPrice]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%.2f",[LACHelperMethods getDefaultCurrency], discountAmount]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency],invItem.vatAmount]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], invItem.total]], nil];
        
        int calcColumnWidth = 0;
        int newOriginX = origin.x;
        int newOriginY = lastyOriginPosition;
        
        for (int j = 0; j < numberOfColumns; j++)
        {
            switch (j) {
                case 0:
                    calcColumnWidth = 295;
                    
                    if ([invItem.itemDescription contains:@"\n"]) {
                        NSString *str = invItem.itemDescription;
                        NSArray *arr = [str componentsSeparatedByString:@"\n"];
                        
                        for (int k =0; k < [arr count]; k++) {
                            
                            NSString *currentString = [arr objectAtIndex:k];
                            int stringLength = [currentString length];
                            int rowsRequired =  stringLength / 70;
                            additionalRows = additionalRows + rowsRequired;
                        }
                        
                        int spaces = [arr count]-1;
                        currentRowHeight = 11 * (additionalRows + spaces);
                    }
                    else
                    {
                        NSString *currentString = invItem.itemDescription;
                        int stringLength = [currentString length];
                        int rowsRequired = 1;
                        
                        if (stringLength > 70) {
                            rowsRequired =  stringLength / 70;
                            rowsRequired = 1 + rowsRequired;
                        }
                        
                        currentRowHeight = 11 * rowsRequired;
                        
                    }
                    
                    break;
                case 1:
                    calcColumnWidth = 60;
                    break;
                case 2:
                    calcColumnWidth = 60;
                    break;
                case 3:
                    calcColumnWidth = 60;
                    break;
                case 4:
                    calcColumnWidth = 60;
                    break;
                case 5:
                    calcColumnWidth = 59;
                    break;
                default:
                    calcColumnWidth = 10;
                    break;
            }
            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, calcColumnWidth, currentRowHeight);
            [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame];
            newOriginX = newOriginX + calcColumnWidth;
        }
        
        lastyOriginPosition = lastyOriginPosition + currentRowHeight;
        NSLog(@"lastyOriginPosition: %i", lastyOriginPosition);
    }
}



/*
+(void)drawNonVATTableDataAt:(CGPoint)origin
         withRowHeight:(int)rowHeight
        andColumnWidth:(int)columnWidth
           andRowCount:(int)numberOfRows
        andColumnCount:(int)numberOfColumns
{
    int padding = 1;
    
    
    int lastyOriginPosition = origin.y;
    int currentRowHeight;
    
    for(int i = 0; i < [invoiceItemsArray count]; i++)
    {
        
        InvoiceItem *invItem = [invoiceItemsArray objectAtIndex:i];
        
        float quantity = [invItem.quantity floatValue];
        float unitPrice = [invItem.unitPrice floatValue];
        float discountRate = [invItem.discountRate floatValue];
        
        float discountAmount = 0.0;
        
        float discountMultiplier = 1;
        
        float total = quantity * unitPrice;
        
        if (discountRate > 0) {
            discountMultiplier = discountRate / 100; //(100 - discountRate) / 100;
            discountAmount = (total * discountMultiplier);
        }
        
        NSArray* infoToDraw = [NSArray arrayWithObjects:[NSString checkForNilString:invItem.itemDescription], [NSString checkForNilString:invItem.quantity], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@",[LACHelperMethods getDefaultCurrency],invItem.unitPrice]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%.2f",[LACHelperMethods getDefaultCurrency], discountAmount]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], invItem.total]], nil];
        
        NSLog(@"item description %@", invItem.itemDescription);
        
        NSLog(@"item total %@", invItem.total);
        
        
        
        int calcColumnWidth = 0;
        int newOriginX = origin.x;
        
        
        for (int j = 0; j < numberOfColumns; j++)
        {
            switch (j) {
                case 0:
                    calcColumnWidth = 353;
                    break;
                case 1:
                    calcColumnWidth = 60;
                    break;
                case 2:
                    calcColumnWidth = 60;
                    break;
                case 3:
                    calcColumnWidth = 60;
                    break;
                case 4:
                    calcColumnWidth = 60;
                    break;
                default:
                    calcColumnWidth = 10;
                    break;
            }
            
            
            currentRowHeight = rowHeight;
          
            int newOriginY = lastyOriginPosition;
            
            if ([invItem.itemDescription contains:@"\n"]) {
                NSString *str = invItem.itemDescription;
                NSArray *arr = [str componentsSeparatedByString:@"\n"];
                currentRowHeight = 11 * ([arr count]);
            }
            
             CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, calcColumnWidth, currentRowHeight);
            
            [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame];
            
            newOriginX = newOriginX + calcColumnWidth;
        }
        
        lastyOriginPosition = lastyOriginPosition + currentRowHeight;
        
    }
}
*/

+(void)drawNonVATTableDataAt:(CGPoint)origin
               withRowHeight:(int)rowHeight
              andColumnWidth:(int)columnWidth
                 andRowCount:(int)numberOfRows
              andColumnCount:(int)numberOfColumns
{
    int padding = 1;
    
    int lastyOriginPosition = origin.y;
    int currentRowHeight;
    
    NSLog(@"invoice Items Array Count: %i", [invoiceItemsArray count]);
    
    for(int i = 0; i < [invoiceItemsArray count]; i++)
    {
        
        InvoiceItem *invItem = [invoiceItemsArray objectAtIndex:i];
        NSLog(@"item: %@", invItem.itemDescription);
    }
    
    
    for(int i = 0; i < [invoiceItemsArray count]; i++)
    {
        int additionalRows = 0;
        
                NSLog(@"item i = %i", i);
        
        InvoiceItem *invItem = [invoiceItemsArray objectAtIndex:i];
        
        NSLog(@"invoice item: %@", invItem.itemDescription);
        
        float quantity = [invItem.quantity floatValue];
        float unitPrice = [invItem.unitPrice floatValue];
        float discountRate = [invItem.discountRate floatValue];
        
        float discountAmount = 0.0;
        
        float discountMultiplier = 1;
        
        float total = quantity * unitPrice;
        
        if (discountRate > 0) {
            discountMultiplier = discountRate / 100; //(100 - discountRate) / 100;
            discountAmount = (total * discountMultiplier);
        }
        
         NSArray* infoToDraw = [NSArray arrayWithObjects:[NSString checkForNilString:invItem.itemDescription], [NSString checkForNilString:invItem.quantity], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@",[LACHelperMethods getDefaultCurrency],invItem.unitPrice]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%.2f",[LACHelperMethods getDefaultCurrency], discountAmount]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], invItem.total]], nil];
        
        
        int calcColumnWidth = 0;
        int newOriginX = origin.x;
        currentRowHeight = rowHeight;
        int newOriginY = lastyOriginPosition;
        
        for (int j = 0; j < numberOfColumns; j++)
        {
            switch (j) {
                case 0:
                    calcColumnWidth = 353;
                    
                    if ([invItem.itemDescription contains:@"\n"]) {
                        NSString *str = invItem.itemDescription;
                        NSArray *arr = [str componentsSeparatedByString:@"\n"];
                        
                        for (int k =0; k < [arr count]; k++) {
                            
                            NSString *currentString = [arr objectAtIndex:k];
                            int stringLength = [currentString length];
                            int rowsRequired =  stringLength / 70;
                            additionalRows = additionalRows + rowsRequired;
                            
                        }
                        
                        int spaces = [arr count]-1;
                        currentRowHeight = 11 * (additionalRows + spaces);
                    }
                    else
                    {
                        NSString *currentString = invItem.itemDescription;
                        int stringLength = [currentString length];
                        int rowsRequired = 1;
                        
                        if (stringLength > 70) {
                            rowsRequired =  stringLength / 70;
                            rowsRequired = (1 + rowsRequired);
                        }
                        
                        currentRowHeight = 11 * (rowsRequired);
                        
                    }
                    
                    break;
                case 1:
                    calcColumnWidth = 60;
                    break;
                case 2:
                    calcColumnWidth = 60;
                    break;
                case 3:
                    calcColumnWidth = 60;
                    break;
                case 4:
                    calcColumnWidth = 60;
                    break;
                default:
                    calcColumnWidth = 10;
                    break;
            }
            
            
            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, calcColumnWidth, currentRowHeight);
            
            [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame];
            
            newOriginX = newOriginX + calcColumnWidth;
        }
        
        lastyOriginPosition = lastyOriginPosition + currentRowHeight;
        
        NSLog(@"lastyOriginPosition: %i", lastyOriginPosition);
        
    }
}




@end
