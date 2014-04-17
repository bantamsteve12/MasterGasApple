//
//  LACHelperMethods.m
//  MasterGas
//
//  Created by Stephen Lalor on 21/02/2013.
//  Copyright (c) 2013 Stephen Lalor. All rights reserved.
//

#import "LACHelperMethods.h"
#import "NSString+Additions.h"
#import "NSUserDefaults+MPSecureUserDefaults.h"
#import "SDCoreDataController.h"
#import "SDSyncEngine.h"
#import "Company.h"
#import "Email.h"
#import "Footer.h"

@implementation LACHelperMethods

@synthesize managedObjectContext;


+ (void)showBasicOKAlertMessage:(NSString *)title withMessage:(NSString *)message{

// alert
UIAlertView *alert = [[UIAlertView alloc]
                      initWithTitle: title
                      message:message
                      delegate: nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil];

    [alert show];
}

+ (void)setCompanyStandardVatRate:(NSString *)standardVat
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:standardVat forKey:@"companyStandardVatRate"];
    [prefs synchronize];
}

+ (NSString *)getCompanyStandardVatRate
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *companyStandardVatRate = [prefs valueForKey:@"companyStandardVatRate"];
 
    if (companyStandardVatRate.length < 1) {
        companyStandardVatRate = @"0.00";
    }
    return [NSString checkForNilString:companyStandardVatRate];
}

+ (NSString *)YesNoNASegementControlValue:(int)selectedIndex
{
    if (selectedIndex == 0) {
        return @"Not Set";
    }
    else if(selectedIndex == 1)
    {
        return @"Yes";
    }
    else if (selectedIndex == 2)
    {
        return @"No";
    }
    else if (selectedIndex == 3)
    {
        return @"N/A";
    }
    else
    {
        return @"Not Set";
    }
}

+ (int)YesNoNASegementControlSelectedIndexForValue:(NSString *)value
{
    if ([value isEqualToString:@"Not Set"]) {
        return [@"0" intValue];
    }
    else if ([value isEqualToString:@"Yes"]) {
        return [@"1" intValue];
    }
    else if ([value isEqualToString:@"No"]) {
        return [@"2" intValue];
    }
    else if ([value isEqualToString:@"N/A"]) {
        return [@"3" intValue];
    }
    else
    {
        return [@"0" intValue];
    }
}

+ (NSString *)PassFailNASegementControlValue:(int)selectedIndex
{
    if (selectedIndex == 0) {
        return @"Not Set";
    }
    else if(selectedIndex == 1)
    {
        return @"Pass";
    }
    else if (selectedIndex == 2)
    {
        return @"Fail";
    }
    else if (selectedIndex == 3)
    {
        return @"N/A";
    }
    else
    {
        return @"Not Set";
    }
}

+ (int)PassFailNASegementControlSelectedIndexForValue:(NSString *)value
{
    if ([value isEqualToString:@"Not Set"]) {
        return [@"0" intValue];
    }
    else if ([value isEqualToString:@"Pass"]) {
        return [@"1" intValue];
    }
    else if ([value isEqualToString:@"Fail"]) {
        return [@"2" intValue];
    }
    else if ([value isEqualToString:@"N/A"]) {
        return [@"3" intValue];
    }
    else
    {
        return [@"0" intValue];
    }
}


+ (NSString *)TrueFalseNASegementControlValue:(int)selectedIndex;
{
    if (selectedIndex == 0) {
        return @"Not Set";
    }
    else if(selectedIndex == 1)
    {
        return @"True";
    }
    else if (selectedIndex == 2)
    {
        return @"False";
    }
    else if (selectedIndex == 3)
    {
        return @"N/A";
    }
    else
    {
        return @"Not Set";
    }
}

+ (int)TrueFalseNASegementControlSelectedIndexForValue:(NSString *)value;
{
    if ([value isEqualToString:@"Not Set"]) {
        return [@"0" intValue];
    }
    else if ([value isEqualToString:@"True"]) {
        return [@"1" intValue];
    }
    else if ([value isEqualToString:@"False"]) {
        return [@"2" intValue];
    }
    else if ([value isEqualToString:@"N/A"]) {
        return [@"3" intValue];
    }
    else
    {
        return [@"0" intValue];
    }
}


// generate md5 has from string
+ (NSString *) returnMD5Hash:(NSString *)concat
{
    const char *concat_str = [concat UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    
    for (int i=0; i<16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
}

/*
+(void)setFullUser:(NSString *)expiry
{
    NSLog(@"expiry: %@", expiry);
    
   // NSString *extendedDate = [expiry stringByAppendingString:@" 23:59:59"];
    
  //  NSLog(@"extendedDate: %@", extendedDate);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *expiryDate2 = [df dateFromString: expiry];

    NSLog(@"expiryDate2: %@", expiryDate2);
    
  //  NSDate *myDate = [NSDate date];
//    NSTimeInterval myDateTimeInterval = [expiryDate2 timeIntervalSince1970];
//    [[NSUserDefaults standardUserDefaults] setDouble:myDateTimeInterval forKey:@"myDateKey"];
 //   [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:expiryDate2 forKey:@"myDateKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //2013-10-27
    //1359245400
    
    
//    NSLog(@"expiry in milliseconds %f", expiryInMilliseconds);
 //   NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setObject:@"username" forKey:@"username"];

    
  //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    //[defaults setObject:intervalString forKey:@"test5"];

     //  [defaults setDouble:expiryInMilliseconds forKey:@"test3"];
    
    
    // [defaults setObject:[NSNumber numberWithDouble:[expiryDate2 timeIntervalSince1970]] forKey:@"TEST4"];
    
    //  [defaults setFloat:expInMilliseconds  forKey:@"dplOffset"];
    //  [defaults setDouble:expiryInMilliseconds forKey:@"expMilliseconds"];
    
    //[defaults setSecureFloat:expInMilliseconds forKey:@"dplOffset"];
  //  [defaults synchronize];
    //[[NSUserDefaults standardUserDefaults] synchronize];
} */

+(bool)fullUser
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"timeStamp: %@",[prefs valueForKey:@"timeStamp"]);
   
        NSTimeInterval todayInMilliseconds = [[NSDate date] timeIntervalSince1970];
        NSLog(@"todayInMilliseconds %f", todayInMilliseconds);
    
        double timeInterval = [[prefs valueForKey:@"timeStamp"] doubleValue];
        NSTimeInterval expiryInMilliseconds = timeInterval;
    
        NSLog(@"expiryInMilliseconds: %f", expiryInMilliseconds);
        double difference = expiryInMilliseconds - todayInMilliseconds;
    
        NSLog(@"difference: %f", difference);
    
        if (difference > 0) {
            NSLog(@"subscription OK");
            return YES;
        }
        else if (difference < 0)
        {
            NSLog(@"subscription expired");
            return NO;
        }
        else
        {
            NSLog(@"something went wrong");
            return NO;
        }

}


+(bool)companyRecordPresent:(NSManagedObjectContext *)mo
{
    NSArray *companyRecords;
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Company"];
    
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
    companyRecords = [mo executeFetchRequest:request error:&error];
    
    NSLog(@"no of company records: %i", [companyRecords count]);
    
    if (companyRecords.count > 0) {
        return YES;
    }
    else
    {
        return NO;
    }

}



+(void)checkUserSubscriptionInCloud{
    
    Reachability* reachabilityServer = [Reachability reachabilityWithHostname:@"www.mastergas.co.uk"];
    NetworkStatus remoteHostStatus = [reachabilityServer currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        // show message
        UIAlertView *noInternet = [[UIAlertView alloc] initWithTitle: @"No Internet Connection"
                                                             message: @"Internet connection not currently available, please check your Wifi/3G settings and try again."
                                                            delegate: self
                                                   cancelButtonTitle: @"OK"
                                                   otherButtonTitles: nil];
        [noInternet show];
        
        
    }
    else
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSLog(@"login button pressed");
        NSDictionary *loginResponse = [LACHelperMethods loginServiceCall];
        NSLog(@"Url feed: %@", [loginResponse valueForKey:@"account"]);
        
        NSString *loginResult = [loginResponse valueForKey:@"account"];
        
        NSString *exp = [loginResponse valueForKey:@"exp"];
        NSLog(@"exp response: %@", exp);
        
        
        if ([loginResult isEqualToString:@"ValidUser"]) {
            NSLog(@"Login result is a valid user");
            
            // save timestamp
            [prefs setObject:exp forKey:@"timeStamp"];
            [prefs synchronize];
            
        }
    }
}


+(NSDictionary *) loginServiceCall
{
    // calls login service on the server to login the phone.

    NSString *usernameField;
    NSString *passwordField;

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    usernameField = [prefs objectForKey:@"Username"];
    passwordField = [prefs objectForKey:@"Password"];
    
    
    // NSString *serviceLocationOne = [prefs objectForKey:@"serviceLocationOne"];
    
    NSString *serviceLocationOne = @"http://www.mastergas.co.uk/paypal";
    
    NSString *serviceLocationTwo = [prefs objectForKey:@"serviceLocationTwo"];
    
    // check main server available, if not use back-up server
    Reachability* reachabilityServer = [Reachability reachabilityWithHostname:@"www.mastergas.co.uk"];
    NetworkStatus remoteHostStatus = [reachabilityServer currentReachabilityStatus];
    
    NSString *serverToUse;
    
    if (remoteHostStatus == ReachableViaWiFi || remoteHostStatus == ReachableViaWWAN) {
        serverToUse = serviceLocationOne;
    }
    else
    {
        serverToUse = serviceLocationTwo;
    }
    
    // hash password
    NSString *hashPassword = [LACHelperMethods returnMD5Hash:passwordField];
    
    NSString *serviceCallPath = serverToUse;    // build up string with params
    serviceCallPath = [serviceCallPath stringByAppendingString:@"/deviceLogin.php?email="];
    serviceCallPath = [serviceCallPath stringByAppendingString:usernameField];
    serviceCallPath = [serviceCallPath stringByAppendingString:@"&password="];
    serviceCallPath = [serviceCallPath stringByAppendingString:hashPassword];
    
    
    NSLog(@"serviceCallPath = %@",serviceCallPath);
    
	id response = [LACHelperMethods objectWithUrl:[NSURL URLWithString:serviceCallPath]];
    
	NSDictionary *loginResponse = (NSDictionary *)response;
	return loginResponse;
    
    
    
}

+(NSString *)stringWithUrl:(NSURL *)url
{
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:nil
                                            timeoutInterval:30];
    // Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
    
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
 	// Construct a String around the Data from the response
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}


+(id) objectWithUrl:(NSURL *)url
{
	SBJsonParser *jsonParser = [SBJsonParser new];
	NSString *jsonString = [LACHelperMethods stringWithUrl:url];
    
	// Parse the JSON into an Object
	return [jsonParser objectWithString:jsonString error:NULL];
}





+(void)setEmailPreferencesInNSDefaults:(NSManagedObjectContext *)mo
{
  
    NSArray *emailRecords;
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Email"];
    
    
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:@"companyId" ascending:YES]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
    emailRecords = [mo executeFetchRequest:request error:&error];
    
    NSLog(@"no of email records: %i", [emailRecords count]);
    
    if (emailRecords.count > 0) {
        
        
        Email *email = [emailRecords objectAtIndex:0];
        NSLog(@"ccEmailAddress: %@", email.ccEmailAddress);
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:email.invoiceBodyText forKey:@"invoiceBodyText"];
        [prefs setObject:email.ccEmailAddress forKey:@"ccEmailAddress"];
        [prefs setObject:email.bccEMailAddress forKey:@"bccEMailAddress"];
        [prefs setObject:email.certificateBodyText forKey:@"certificateBodyText"];
        [prefs setObject:email.estimateBodyText forKey:@"estimateBodyText"];
        
        
        [prefs synchronize];
        
    }
 
}

+(void)setFooterPreferencesInNSDefaults:(NSManagedObjectContext *)mo
{
    NSArray *footerRecords;
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Footer"];
    
    
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:@"companyId" ascending:YES]]];
  //  [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
    footerRecords = [mo executeFetchRequest:request error:&error];
    
    
    if (footerRecords.count > 0) {
        
        Footer *footer = [footerRecords objectAtIndex:0];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:footer.invoiceFooterNotes forKey:@"invoiceFooterNotes"];
        [prefs setObject:footer.estimateFooterNotes forKey:@"estimateFooterNotes"];
        [prefs synchronize];
        
    }

}

+(void)setUserPreferencesInNSDefaults:(NSManagedObjectContext *)mo
{
        NSArray *companyRecords;
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Company"];
        
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"syncStatus != %d", SDObjectDeleted]];
        companyRecords = [mo executeFetchRequest:request error:&error];

        NSLog(@"no of company records: %i", [companyRecords count]);

    if (companyRecords.count > 0) {
        
        Company *company = [companyRecords objectAtIndex:0];
    
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:company.standardCompanyVatAmount forKey:@"companyStandardVatRate"];
        [prefs setObject:company.companyAddressLine1 forKey:@"companyAddressLine1"];
        [prefs setObject:company.companyAddressLine2 forKey:@"companyAddressLine2"];
        [prefs setObject:company.companyAddressLine3 forKey:@"companyAddressLine3"];
        [prefs setObject:company.companyEmailAddress forKey:@"companyEmailAddress"];
        [prefs setObject:company.companyGSRNumber forKey:@"companyGSRNumber"];
        [prefs setObject:company.companyGSRNumber forKey:@"companyId"];
        [prefs setObject:company.companyGSRNumber forKey:@"companyMobileNumber"];
        [prefs setObject:company.companyGSRNumber forKey:@"companyName"];
        [prefs setObject:company.companyGSRNumber forKey:@"companyPostcode"];
        [prefs setObject:company.companyGSRNumber forKey:@"companyTelNumber"];
        [prefs setObject:company.companyGSRNumber forKey:@"companyVATNumber"];
        [prefs setObject:company.companyCompaniesHouseRegNumber forKey:@"companyCompaniesHouseRegNumber"];
        [prefs setObject:company.defaultCurrency forKey:@"defaultCurrency"];
        [prefs synchronize];
    }
}


+(NSString *)getCompanyName
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *value = [prefs objectForKey:@"companyName"];
    return value;
}

+(NSString *)getDefaultCurrency
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *value = [prefs objectForKey:@"defaultCurrency"];
    
    if (value.length > 0) {
        return value;
    }
    else
    {
        return @"£";
    }
}


+(int)SegementIndexValue:(NSArray *)items withValue:(NSString *)value
{
    for (int i=0; i<[items count]; i++) {
        
        if ([items[i] isEqualToString:value]) {
            return i;
        }
    }
    return 0;
}

+(NSString *)ValueForIndex:(NSArray *)items withIndex:(int *)indexValue
{
    NSLog(@"indexValue: %i", indexValue);
    
    return [items objectAtIndex:indexValue];
}

/*

+(void)setDocumentHeaderBackgroundColour:(UIColor *)colour
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *value = [prefs objectForKey:@"companyName"];
    return value;

}

+(void)setDocumentHeaderTextColour:(UIColor *)colour
{
    
}

+(UIColor *)getDocumentHeaderBackgroundColour
{
    
}

+(UIColor *)getDocumentHeaderTextColour
{
    
}
*/


@end
