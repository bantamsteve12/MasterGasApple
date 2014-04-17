//
//  PDFEstimateRenderer.m
//  MasterGas
//
//  Created by Stephen Lalor on 23/11/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "PDFEstimateRenderer.h"
#import "CoreText/CoreText.h"
#import "UIColor+Additions.h"
#import "NSString+Additions.h"
#import "Company.h"
#import "LACHelperMethods.h"



@implementation PDFEstimateRenderer

@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize estimateItems;

Estimate *est;
Company *company;

NSMutableArray *estimateItemsArray;


//+(void)drawPDF:(NSString*)fileName withInvoice:(Invoice *)invoice withInvoiceItems:(NSMutableArray *)invoiceItems;

+(void)drawPDF:(NSString*)fileName withEstimate:(Estimate *)estimate withEstimateItems:(NSMutableArray *)estimateItems withCompanyRecord:(Company *)companyRecord;
{
    
    estimateItemsArray = estimateItems;
    est = estimate;
    company = companyRecord;
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    [self drawLabels];
    [self drawLogo];
    
    
    int xOrigin = 7;
    int yOrigin = 192;
    
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
    else if (label.tag == 333) {
        backgroundColor   = [UIColor colorWithR:54 G:100 B:139 A:1];
    }
    else if(label.tag == 880)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *str = [prefs valueForKey:@"estimateFooterNotes"];
        
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
    else if (label.tag == 2) {
        textColor = [UIColor whiteColor];
        color = textColor.CGColor;
        font = CTFontCreateWithName((CFStringRef) @"System",10.0, NULL);
        theAlignment = kCTCenterTextAlignment;
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
        objects = [[NSBundle mainBundle] loadNibNamed:@"Estimate" owner:nil options:nil];
    }
    else
    {
        objects = [[NSBundle mainBundle] loadNibNamed:@"EstimateNoVat" owner:nil options:nil];
    }
    
    // NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"Invoice" owner:nil options:nil];
    
    UIView* mainView = [objects objectAtIndex:0];
    
    for (UIView* view in [mainView subviews]) {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*)view;
            
            
            switch(label.tag)
            {
                case 4:
                {
                    NSString *str = est.type;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                case 21:{
                    
                    NSString *str = est.customerName;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 22:{
                    
                    NSString *str = est.customerAddressLine1;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 23:{
                    
                    NSString *str = est.customerAddressLine2;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 24:{
                    
                    NSString *str = est.customerAddressLine3;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 25:{
                    
                    NSString *str = est.customerPostcode;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 26:{
                    
                    NSString *str = est.customerTelephone;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 27:{
                    
                    NSString *str = est.customerMobile;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 30:{
                    
                    NSString *str = est.uniqueEstimateNo;
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
                    
                    str = [dateFormatter stringFromDate:est.date];
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;
                }
                    
                    
                    
                    
                case 33:{
                    
                    NSString *str = est.terms;
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
                    NSString *str = est.reference;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 39:{
                    NSString *str = est.workOrderReference;
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
                    
                    NSString *str = est.subtotal;
                    if (str.length > 0) {
                        label.text = [NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 51:{
                    
                    NSString *str = est.vat;
                    if (str.length > 0) {
                        label.text = [NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 52:{
                    
                    NSString *str = est.total;
                    if (str.length > 0) {
                        label.text = [NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], str];
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
               
                    
                    
                case 61:{
                    
                    NSString *str = est.siteName;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 62:{
                    
                    NSString *str = est.siteAddressLine1;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 63:{
                    
                    NSString *str = est.siteAddressLine2;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 64:{
                    
                    NSString *str = est.siteAddressLine3;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 65:{
                    
                    NSString *str = est.sitePostcode;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 66:{
                    
                    NSString *str = est.siteTelephone;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 67:{
                    
                    NSString *str = est.siteMobile;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                    
                case 880:{
                    
                    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                    NSString *str = [prefs valueForKey:@"estimateFooterNotes"];
                 
                   if (str.length > 0) {
                       label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;
                }
                    
            }
            [self drawText:label.text inFrame:label.frame withUILabel:label];
        }
    }
    
}


+(void)drawLogo
{
    NSArray* objects;
    
    if (company.companyVATNumber.length > 0) {
        objects = [[NSBundle mainBundle] loadNibNamed:@"Estimate" owner:nil options:nil];
    }
    else
    {
        objects = [[NSBundle mainBundle] loadNibNamed:@"EstimateNoVat" owner:nil options:nil];
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


+(void)drawTableDataAt:(CGPoint)origin
         withRowHeight:(int)rowHeight
        andColumnWidth:(int)columnWidth
           andRowCount:(int)numberOfRows
        andColumnCount:(int)numberOfColumns
{
    int padding = 1;
    
    int lastyOriginPosition = origin.y;
    int currentRowHeight;
    
    
    for(int i = 0; i < [estimateItemsArray count]; i++)
    {
        
        int additionalRows = 1;
        
        EstimateItem *estItem = [estimateItemsArray objectAtIndex:i];
        
        float quantity = [estItem.quantity floatValue];
        float unitPrice = [estItem.unitPrice floatValue];
        float discountRate = [estItem.discountRate floatValue];
        float discountAmount = 0.0;
        float discountMultiplier = 1;
        float total = quantity * unitPrice;
        
        if (discountRate > 0) {
            discountMultiplier = discountRate / 100; //(100 - discountRate) / 100;
            discountAmount = (total * discountMultiplier);
        }
        
        NSArray* infoToDraw = [NSArray arrayWithObjects:[NSString checkForNilString:estItem.itemDescription], [NSString checkForNilString:estItem.quantity], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@",[LACHelperMethods getDefaultCurrency],estItem.unitPrice]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%.2f",[LACHelperMethods getDefaultCurrency], discountAmount]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency],estItem.vatAmount]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], estItem.total]], nil];
        
        int calcColumnWidth = 0;
        int newOriginX = origin.x;
        int newOriginY = lastyOriginPosition;
   
        for (int j = 0; j < numberOfColumns; j++)
        {
            switch (j) {
                case 0:
                    calcColumnWidth = 297;
                    
                    if ([estItem.itemDescription contains:@"\n"]) {
                        NSString *str = estItem.itemDescription;
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
                        NSString *currentString = estItem.itemDescription;
                        int stringLength = [currentString length];
                        int rowsRequired = 1;
                        
                        if (stringLength > 80) {
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




+(void)drawNonVATTableDataAt:(CGPoint)origin
               withRowHeight:(int)rowHeight
              andColumnWidth:(int)columnWidth
                 andRowCount:(int)numberOfRows
              andColumnCount:(int)numberOfColumns
{
    int padding = 1;
    
    int lastyOriginPosition = origin.y;
    int currentRowHeight;
   

    NSLog(@"estimate Items Array Count: %i", [estimateItemsArray count]);
    
    for(int i = 0; i < [estimateItemsArray count]; i++)
    {
        
        EstimateItem *estItem = [estimateItemsArray objectAtIndex:i];
        NSLog(@"item: %@", estItem.itemDescription);
    }
    
    
    for(int i = 0; i < [estimateItemsArray count]; i++)
    {
         int additionalRows = 0;
        
        
        
        NSLog(@"item i = %i", i);
        
        EstimateItem *estItem = [estimateItemsArray objectAtIndex:i];
        
        
       NSLog(@"estimate item: %@", estItem.itemDescription);
        
        float quantity = [estItem.quantity floatValue];
        float unitPrice = [estItem.unitPrice floatValue];
        float discountRate = [estItem.discountRate floatValue];
        
        float discountAmount = 0.0;
        
        float discountMultiplier = 1;
        
        float total = quantity * unitPrice;
        
        if (discountRate > 0) {
            discountMultiplier = discountRate / 100; //(100 - discountRate) / 100;
            discountAmount = (total * discountMultiplier);
        }
        
        NSArray* infoToDraw = [NSArray arrayWithObjects:[NSString checkForNilString:estItem.itemDescription], [NSString checkForNilString:estItem.quantity], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@",[LACHelperMethods getDefaultCurrency],estItem.unitPrice]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%.2f",[LACHelperMethods getDefaultCurrency], discountAmount]], [NSString checkForNilString:[NSString stringWithFormat:@"%@%@", [LACHelperMethods getDefaultCurrency], estItem.total]], nil];
        
        
        
        int calcColumnWidth = 0;
        int newOriginX = origin.x;
        
        currentRowHeight = rowHeight;
        
        int newOriginY = lastyOriginPosition;
       
        
       
        for (int j = 0; j < numberOfColumns; j++)
        {
            switch (j) {
                case 0:
                    calcColumnWidth = 357;
                    
                    if ([estItem.itemDescription contains:@"\n"]) {
                        NSString *str = estItem.itemDescription;
                        NSArray *arr = [str componentsSeparatedByString:@"\n"];
                        
                        for (int k =0; k < [arr count]; k++) {
                            
                            NSString *currentString = [arr objectAtIndex:k];
                            int stringLength = [currentString length];
                            int rowsRequired =  stringLength / 85;
                            additionalRows = additionalRows + rowsRequired;
                            
                        }
                        
                        int spaces = [arr count]-1;
                        currentRowHeight = 11 * (additionalRows + spaces);
                    }
                    else
                    {
                        NSString *currentString = estItem.itemDescription;
                        int stringLength = [currentString length];
                        int rowsRequired = 1;
                        
                        if (stringLength > 80) {
                            rowsRequired =  stringLength / 80;
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
