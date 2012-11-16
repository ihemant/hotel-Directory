
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface RSGEvent : NSObject <MKAnnotation>{
	float latitude;
	float longitude;
	float magnitude;
	float depth;
	
	NSString *mTitle;
	NSString *mSubTitle;
}
@property (nonatomic, retain) NSString *mTitle;
@property (nonatomic, retain) NSString *mSubTitle;



@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) float magnitude;
@property (nonatomic) float depth;

//MKAnnotation
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
