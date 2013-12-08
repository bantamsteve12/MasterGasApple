//
//  FooterNotesTVC.h
//  MasterGas
//
//  Created by Stephen Lalor on 03/12/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterNotesTVC : UITableViewController


@property (strong, nonatomic) IBOutlet UITextView *estimateFooterNotesTextViewField;
@property (strong, nonatomic) IBOutlet UITextView *invoiceFooterNotesTextViewField;


@property (strong, nonatomic) NSString *entityName;
@property (nonatomic, strong) NSArray *footerNotes;
@property (strong, nonatomic) void (^updateCompletionBlock)(void);


@end


