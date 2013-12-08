//
//  Invoice.h
//  MasterGas
//
//  Created by Stephen Lalor on 04/12/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Invoice : NSManagedObject

@property (nonatomic, retain) NSString * balanceDue;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * companyId;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * customerAddressLine1;
@property (nonatomic, retain) NSString * customerAddressLine2;
@property (nonatomic, retain) NSString * customerAddressLine3;
@property (nonatomic, retain) NSString * customerEmail;
@property (nonatomic, retain) NSString * customerId;
@property (nonatomic, retain) NSString * customerMobile;
@property (nonatomic, retain) NSString * customerName;
@property (nonatomic, retain) NSString * customerPostcode;
@property (nonatomic, retain) NSString * customerTelephone;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * due;
@property (nonatomic, retain) NSString * engineerId;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * paid;
@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) NSString * subtotal;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSString * terms;
@property (nonatomic, retain) NSString * total;
@property (nonatomic, retain) NSString * uniqueInvoiceNo;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * vat;
@property (nonatomic, retain) NSString * workOrderReference;
@property (nonatomic, retain) NSString * siteAddressLine1;
@property (nonatomic, retain) NSString * siteAddressLine2;
@property (nonatomic, retain) NSString * siteAddressLine3;
@property (nonatomic, retain) NSString * siteEmail;
@property (nonatomic, retain) NSString * siteId;
@property (nonatomic, retain) NSString * siteMobile;
@property (nonatomic, retain) NSString * siteName;
@property (nonatomic, retain) NSString * sitePostcode;
@property (nonatomic, retain) NSString * siteTelephone;

@end
