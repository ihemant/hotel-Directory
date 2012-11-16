
#import "RSGEvent.h"


@implementation RSGEvent
@synthesize latitude;
@synthesize longitude;
@synthesize magnitude;
@synthesize depth;

@synthesize coordinate, mTitle, mSubTitle;

- (NSString *)subtitle{
	NSLog(@"\nsub Title --> %@",self.mSubTitle);
	return mSubTitle;
}

- (NSString *)title{
	return mTitle;
}

- (CLLocationCoordinate2D)coordinate
{
	CLLocationCoordinate2D coord = {self.latitude, self.longitude};
	return coord;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"%1.3f, %1.3f, %1.3f, %1.1f", 
			self.latitude, self.longitude, self.magnitude, self.depth];
}

@end
