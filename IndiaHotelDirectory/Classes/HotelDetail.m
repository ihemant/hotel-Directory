
#import "HotelDetail.h"
#import "Hotels.h"
#import "MapViewController.h"
#import "WebsiteViewController.h"
@implementation HotelDetail
@synthesize hotelName,hotelAddress,hotelTelephone,hotelFax,hotelEmail,hotelWebsite,hotelCity,index,longitude,latitude;//rating;
@synthesize websiteAddress;
@synthesize rateView = _rateView;
@synthesize statusLabel = _statusLabel;
@synthesize selectedHotelId, selectedHotelName,image0;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    _statusLabel.text = [NSString stringWithFormat:@"Rating: %f", rating];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
			    
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Map"
																			   style:UIBarButtonItemStylePlain 
																			  target:self
																			  action:@selector(openMap:)]autorelease];
	
	    _rateView.editable = NO;
    _rateView.maxRating = 5;
    _rateView.delegate = self;
	
	self.title = @"Hotel Details";
	[self detailView];
	
}
- (void)viewDidUnload {
    self.rateView = nil;
    self.statusLabel = nil;
}

-(void)detailView{
	_rateView.notSelectedImage = [UIImage imageNamed:@"starOff.png"];
    _rateView.fullSelectedImage = [UIImage imageNamed:@"starOn.png"];
		//NSLog(@"In Fetch data method...");
		NSManagedObjectContext *context = [self managedObjectContext];
		
		NSEntityDescription *entityDescriptionDepartment = [NSEntityDescription entityForName:@"Hotels" inManagedObjectContext:context];
		NSFetchRequest *requestDepartment = [[[NSFetchRequest alloc] init] autorelease];
		[requestDepartment setEntity:entityDescriptionDepartment];
	
	   NSPredicate *predicate= [NSPredicate predicateWithFormat: @"(hotelName == %@)",selectedHotelName];
	   [requestDepartment setPredicate:predicate];
	   NSSortDescriptor *sortDescriptorDepartment = [[NSSortDescriptor alloc] initWithKey:@"hotelName" ascending:YES];
		[requestDepartment setSortDescriptors:[NSArray arrayWithObject:sortDescriptorDepartment]];
		
		NSError *error;
		NSArray *arrayDepartment = [context executeFetchRequest:requestDepartment error:&error];
		[sortDescriptorDepartment release];

			Hotels *obj;
	     obj = [arrayDepartment objectAtIndex:index];
			
			hotelName.text = [obj valueForKey:@"hotelName"];
			
			hotelAddress.text = [obj valueForKey:@"hotelAddress"];
			hotelTelephone.text = [obj valueForKey:@"hotelTelephone"];
			hotelFax.text = [obj valueForKey:@"hotelFax"];
			hotelEmail.text = [obj valueForKey:@"hotelEmail"];
			hotelWebsite.text = [obj valueForKey:@"hotelWebsite"];
			hotelCity.text = [obj valueForKey:@"hotelCity"];
		    _statusLabel.text =[obj valueForKey:@"rating"];
	        _rateView.rating = [[obj valueForKey:@"rating"] intValue];
			longitude.text = [obj valueForKey:@"longitude"];
			latitude.text = [obj valueForKey:@"latitude"];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if (!url) {  return NO; }
	
    NSString *URLString = [url absoluteString];
    [[NSUserDefaults standardUserDefaults] setObject:URLString forKey:@"url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}
-(IBAction)openBrowser:(id)sender{
	WebsiteViewController *websiteView = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
	if ([hotelWebsite.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Website Address Available!! " message:@"Sorry!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	NSString *urlAddress = [NSString stringWithFormat:@"http://%@",hotelWebsite.text];
	websiteView.urlAddress = urlAddress;
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController pushViewController:websiteView animated:YES];	
	}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if(interfaceOrientation == UIInterfaceOrientationPortrait||UIInterfaceOrientationLandscapeLeft||UIInterfaceOrientationLandscapeRight)
		return YES;
}
-(IBAction)openMap:(id)sender{
   MapViewController *mapController = [[MapViewController alloc] initWithNibName:@"MapView" bundle:nil];
	if ([hotelAddress.text isEqualToString:@""])//||[hotelCity.text isEqualToString:@""])
	{
		mapController.location1 = hotelAddress.text;
		mapController.mapSubTitle = hotelAddress.text;
		//mapController.location1 = hotelCity.text;
		//mapController.mapSubTitle = hotelCity.text;
		
	}
	else {
		mapController.location1 = hotelAddress.text;
		mapController.mapSubTitle = hotelAddress.text;
		//mapController.location1 = hotelCity.text;
		//mapController.mapSubTitle = hotelCity.text;

		
	}
	mapController.mapTitle = hotelName.text;
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController pushViewController:mapController animated:YES];
}
-(IBAction)makeCall:(id)sender{
    if ([hotelTelephone.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Telephone Number Available!! " message:@"Sorry!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		
		return;
	}
	
	NSString *callToURLString = [NSString stringWithFormat:@"tel:%@",hotelTelephone.text];
	
	if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:callToURLString]])
	{
		// there was an error trying to open the URL.
		//for the time being we'll ignore it.
	}
	NSLog(@"-----buttonclick");

}

-(IBAction)sendMail:(id)sender{
	[self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([hotelEmail.text isEqualToString:@""]) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Email Address!! " message:@"Sorry!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return;
	}
	
	NSString *subject = [NSString stringWithString:@"Feedback for Dubai Hotel List version 0.2"];
	NSString *emailId = hotelEmail.text;
	NSString *emailIDString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
							   [emailId stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							   [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailIDString]])
	{
		// there was an error trying to open the URL.
		//for the time being we'll ignore it.
	}	
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
		
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"HotelList.sqlite"]];
	//NSLog(@"Path --> %@",storeUrl);
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
	
	

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[hotelName release];
	[hotelAddress release];
	[hotelTelephone release];
	[hotelFax release];
	[hotelEmail release];
	[hotelWebsite release];
	//[predicate release];
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	self.rateView = nil;
    self.statusLabel = nil;
    
	
	[super dealloc];
}


@end
