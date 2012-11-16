
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AddressAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	
	NSString *mTitle;
	NSString *mSubTitle;
}
@property (nonatomic, retain) NSString *mTitle;
@property (nonatomic, retain) NSString *mSubTitle;


@end

@interface MapViewController : UIViewController<MKMapViewDelegate> {
	IBOutlet MKMapView *mapView;
	NSString *location1;
	NSString *mapTitle;
	NSString *mapSubTitle;
	IBOutlet UISegmentedControl *segmentController;

	AddressAnnotation *addAnnotation;
}
@property (nonatomic, retain) NSString *location1;
@property (nonatomic, retain) NSString *mapTitle;
@property (nonatomic, retain) NSString *mapSubTitle;

-(IBAction)segmentControllerAction:(id)sender;


- (void) showAddress;

-(CLLocationCoordinate2D) addressLocation;

@end
