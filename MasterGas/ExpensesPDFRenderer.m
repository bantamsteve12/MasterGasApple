//
//  ExpensesPDFRenderer.m
//  MasterGas
//
//  Created by Stephen Lalor on 06/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "ExpensesPDFRenderer.h"
#import "CoreText/CoreText.h"
#import "UIColor+Additions.h"
#import "NSString+Additions.h"
#import "Company.h"
#import "LACHelperMethods.h"

@implementation ExpensesPDFRenderer

@synthesize managedObjectContext;
@synthesize managedObject;
@synthesize expenseItems;

Expense *exps;
Company *company;

NSString *subTotal;
NSString *vatTotal;
NSString *total;

NSMutableArray *expenseItemsArray;


+(void)drawPDF:(NSString*)fileName withExpenseRecord:(Expense *)expense withExpenseItems:(NSMutableArray *)expenseItems withCompanyRecord:(Company *)companyRecord
{
    
    expenseItemsArray = expenseItems;
    exps = expense;
    company = companyRecord;
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 792, 612), nil);
    
    [self drawLabels];
    [self drawLogo];
    
    
    int xOrigin = 8;
    int yOrigin = 180;
    
    int rowHeight = 13;
    
    int columnWidth = 120;
    
    int numberOfRows = 4;
    int numberOfColumns = 8;
    
    
    [self drawTableDataAt:CGPointMake(xOrigin, yOrigin) withRowHeight:rowHeight andColumnWidth:columnWidth andRowCount:numberOfRows andColumnCount:numberOfColumns];
    
    
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
    else if(label.tag == 3)
    {
        backgroundColor = [UIColor clearColor];
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
    else if (label.tag == 3) {
        textColor = [UIColor blackColor];
        color = textColor.CGColor;
        font = CTFontCreateWithName((CFStringRef) @"System",15.0, NULL);
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
    [self calculateSummaryTotals];
    
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"ExpenseReport" owner:nil options:nil];
    
    UIView* mainView = [objects objectAtIndex:0];
    
    for (UIView* view in [mainView subviews]) {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*)view;
            
            
            switch(label.tag)
            {
                    
                case 10:{
                    
                    NSString *str = exps.engineerName;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
               
                case 17:{
                    
                    NSString *str = company.companyName;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
        
              
                case 18:{
                    
                    NSString *str = company.companyAddressLine1;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 19:{
                    
                    NSString *str = company.companyAddressLine2;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 20:{
                    
                    NSString *str = company.companyAddressLine3;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}

                case 21:{
                    
                    NSString *str = company.companyPostcode;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 22:{
                    
                    NSString *str = company.companyTelNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 23:{
                    
                    NSString *str = company.companyMobileNumber;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                    
                    
                case 30:{
                    
                    NSString *str = exps.uniqueClaimNo;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                    
                case 31:{
                    
                    NSString *str = exps.reference;
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;}
                 
                    
                case 32:{
                    
                    NSString *str;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                  //  [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    [dateFormatter setDateFormat:@"d MMMM yyyy"];
                    
                    str = [dateFormatter stringFromDate:exps.date];
                    
                    if (str.length > 0) {
                        label.text = str;
                    }
                    else {
                        label.text = @"";
                    }
                    break;
                }
            
            
        
            case 40:{
        
                    NSString *str = subTotal;
                if (str.length > 0) {
                    label.text = str;
                }
                else {
                    label.text = @"";
                }
                break;}
        
    
            case 41:{
        
                NSString *str = vatTotal;
                if (str.length > 0) {
                    label.text = str;
                }
                else {
                    label.text = @"";
                }
                break;}
        
            case 42:{
        
                NSString *str = total;
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
    
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"ExpenseReport" owner:nil options:nil];
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   [dateFormatter setDateFormat:@"d/MM/yyyy"];
    
    
    for(int i = 0; i < [expenseItemsArray count]; i++)
    {
        
        ExpenseItem *expsItem = [expenseItemsArray objectAtIndex:i];
    
        
        NSString *dateString = [dateFormatter stringFromDate:expsItem.date];
        
        NSLog(@"Expense Date: = %@", dateString);
        
        NSArray* infoToDraw = [NSArray arrayWithObjects:
                               @"",
                               [NSString checkForNilString:expsItem.itemDescription],
                               [NSString checkForNilString:expsItem.type],
                               [NSString checkForNilString:expsItem.notes],
                               [NSString checkForNilString:dateString],
                               [NSString stringWithFormat:@"%@%@",[LACHelperMethods getDefaultCurrency],[NSString checkForNilString:expsItem.subTotalAmount]],
                               [NSString stringWithFormat:@"%@%@",[LACHelperMethods getDefaultCurrency],[NSString checkForNilString:expsItem.vatAmount]],
                               [NSString stringWithFormat:@"%@%@",[LACHelperMethods getDefaultCurrency],[NSString checkForNilString:expsItem.totalAmount]],
                               nil];
        
    
        
        int calcColumnWidth = 0;
        int newOriginX = origin.x;
        
        
        for (int j = 0; j < numberOfColumns; j++)
        {
            switch (j) {
                case 0:
                    calcColumnWidth = 10;
                    break;
                case 1:
                    calcColumnWidth = 140;
                    break;
                case 2:
                    calcColumnWidth = 120;
                    break;
                case 3:
                    calcColumnWidth = 257;
                    break;
                case 4:
                    calcColumnWidth = 61;
                    break;
                case 5:
                    calcColumnWidth = 62;
                    break;
                case 6:
                    calcColumnWidth = 62;
                    break;
                case 7:
                    calcColumnWidth = 62;
                    break;
                default:
                    calcColumnWidth = 10;
                    break;
            }
            
            
            int newOriginY = origin.y + ((i+1)*rowHeight);
            
            CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, calcColumnWidth, rowHeight);
            
            
            [self drawText:[infoToDraw objectAtIndex:j] inFrame:frame];
            
            newOriginX = newOriginX + calcColumnWidth;
        }
    } 
}


+(void)calculateSummaryTotals
{
   
    if ([expenseItemsArray count] > 0) {
        
        
        NSMutableArray * totalArray = [[NSMutableArray alloc] init];
        NSMutableArray * vatArray = [[NSMutableArray alloc] init];
        NSMutableArray * subTotalArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [expenseItemsArray count]; ++i) {
            ExpenseItem *expsItem = [expenseItemsArray objectAtIndex:i];
            [totalArray addObject:[NSNumber numberWithInt:[expsItem.totalAmount intValue]]];
            [vatArray addObject:[NSNumber numberWithInt:[expsItem.vatAmount intValue]]];
            [subTotalArray addObject:[NSNumber numberWithInt:[expsItem.subTotalAmount intValue]]];

        }
        
    
        double totalSum = 0;
        for (NSNumber * n in totalArray) {
            totalSum += [n doubleValue];
        }
        
        double totalVatSum = 0;
        for (NSNumber * n in vatArray) {
            totalVatSum += [n doubleValue];
        }
        
        double subTotalSum = 0;
        for (NSNumber * n in subTotalArray) {
            subTotalSum += [n doubleValue];
        }
        
        subTotal = [NSString stringWithFormat:@"%.2f", subTotalSum];
        vatTotal = [NSString stringWithFormat:@"%.2f", totalVatSum];
        total = [NSString stringWithFormat:@"%.2f", totalSum];
    } 
    
}


@end
