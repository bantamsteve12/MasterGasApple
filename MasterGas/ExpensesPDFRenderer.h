//
//  ExpensesPDFRenderer.h
//  MasterGas
//
//  Created by Stephen Lalor on 06/07/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Expense.h"
#import "SDSyncEngine.h"
#import "ExpenseItem.h"
#import "Company.h"
#import "LACFileHandler.h"
#import "LACUsersHandler.h"

@interface ExpensesPDFRenderer : NSObject


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObject *managedObject;
@property (nonatomic, strong) NSArray *expenseItems;

+(void)drawPDF:(NSString*)fileName withExpenseRecord:(Expense *)expense withExpenseItems:(NSMutableArray *)expenseItems withCompanyRecord:(Company *)companyRecord;


+(void)drawText;

+(void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;

+(void)drawImage:(UIImage*)image inRect:(CGRect)rect;

+(void)drawText:(NSString*)textToDraw inFrame:(CGRect)frameRect;

+(void)drawLabels;

+(void)drawLogo;


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

- (void)loadRecordsFromCoreData;
+(void)calculateSummaryTotals;

@end
