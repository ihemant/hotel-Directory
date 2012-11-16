//
//  Hotels.h
//  DubaiHotelDirectory
//
//  Created by hemant kumar on 10/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Hotels :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * hotelEmail;
@property (nonatomic, retain) NSString * hotelName;
@property (nonatomic, retain) NSString * rating;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * hotelFax;
@property (nonatomic, retain) NSString * hotelWebsite;
@property (nonatomic, retain) NSString * hotelTelephone;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * hotelAddress;
@property (nonatomic, retain) NSString * hotelCity;

@end



