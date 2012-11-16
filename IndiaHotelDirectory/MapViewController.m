
#import "MapViewController.h"

@implementation AddressAnnotation

@synthesize coordinate, mTitle, mSubTitle;

- (NSString *)subtitle{
	NSLog(@"\nsub Title --> %@",self.mSubTitle);
	return mSubTitle;
}
- (NSString *)title{
	return mTitle;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	//NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}

@end


@implementation MapViewController
@synthesize location1, mapTitle, mapSubTitle;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) showAddress {
	//Hide the keypad
	//[addressField resignFirstResponder];
	
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta=0.01;
	span.longitudeDelta=0.01;
	
	CLLocationCoordinate2D location = [self addressLocation];
	region.span=span;
	region.center=location;
	
	if(addAnnotation != nil) {
		[mapView removeAnnotation:addAnnotation];
		[addAnnotation release];
		addAnnotation = nil;
	}
	
	addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:location];
	[mapView addAnnotation:addAnnotation];
	
	[mapView setRegion:region animated:TRUE];
	[mapView regionThatFits:region];
	addAnnotation.mSubTitle = self.mapSubTitle;
	addAnnotation.mTitle = self.mapTitle;
}

-(CLLocationCoordinate2D) addressLocation {
	NSError *error;
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
							[self.location1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSString *locationString;
	locationString = [NSString
					  stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding 
					  error:&error];
	
	NSArray *listItems = [locationString componentsSeparatedByString:@","];
	
	double latitude = 0.0;
	double longitude = 0.0;
	if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
		latitude = [[listItems objectAtIndex:2] doubleValue];
		longitude = [[listItems objectAtIndex:3] doubleValue];
	}
	else {
		//Show error
	}
	CLLocationCoordinate2D location;
	location.latitude = latitude;
	location.longitude = longitude;
	
	return location;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
	MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
	annView.pinColor = MKPinAnnotationColorGreen;
	annView.animatesDrop=TRUE;
	annView.canShowCallout = YES;
	annView.calloutOffset = CGPointMake(-5, 5);
	return annView;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self showAddress];
	[segmentController addTarget:self
						  action:@selector(segmentControllerAction:)
				forControlEvents:UIControlEventValueChanged];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentController];
}
-(IBAction)segmentControllerAction:(id)sender{
	if(segmentController.selectedSegmentIndex == 0){
		mapView.mapType = MKMapTypeStandard;	
	}
	else if(segmentController.selectedSegmentIndex == 1){
		mapView.mapType = MKMapTypeSatellite;	
		
	}
	else if(segmentController.selectedSegmentIndex == 2){
		mapView.mapType = MKMapTypeHybrid;	
		
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[location1 release], location1 = nil;
	[mapTitle release], mapTitle = nil;
	[mapSubTitle release], mapSubTitle = nil;
	[addAnnotation release], addAnnotation =nil;
	[mapView release], mapView = nil;
	
    [super dealloc];
}


@end
