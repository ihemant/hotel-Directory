

#import "RestaurantDetailView.h"
#import "RestaurantSearch.h"
#import "RootViewController.h"
#import "Restaurants.h"
#import "MapViewController.h"
#import "WebsiteViewController.h"

@implementation RestaurantDetailView
@synthesize restaurantName,restaurantAddress,restaurantCity,restaurantTelephoneNo,restaurantWebsite,restaurantEmail,index,selectedRestaurantName;
-(IBAction)openBrowser:(id)sender{
	WebsiteViewController *websiteView = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];

	if ([restaurantWebsite.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Website Address Available!! " message:@"Sorry!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	NSString *urlAddress = [NSString stringWithFormat:@"http://%@",restaurantWebsite.text];
	websiteView.urlAddress = urlAddress;
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController pushViewController:websiteView animated:YES];
}
-(IBAction)openMap:(id)sender{
	NSLog(@"-----buttonclick");
	
	MapViewController *mapController = [[MapViewController alloc] initWithNibName:@"MapView" bundle:nil];
	if ([restaurantAddress.text isEqualToString:@""]) {
		mapController.location1 = restaurantAddress.text;
		mapController.mapSubTitle = restaurantAddress.text;
		
	}
	else {
		mapController.location1 = restaurantAddress.text;
		mapController.mapSubTitle = restaurantAddress.text;
		
	}
	mapController.mapTitle = restaurantName.text;
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController pushViewController:mapController animated:YES];
}

-(IBAction)makeCall:(id)sender{
    if ([restaurantTelephoneNo.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Telephone Number Available!! " message:@"Sorry!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		
		return;
	}
	
	NSString *callToURLString = [NSString stringWithFormat:@"tel:%@",restaurantTelephoneNo.text];
	
	if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:callToURLString]])
	{
		// there was an error trying to open the URL.
		//for the time being we'll ignore it.
	}
	
}

-(IBAction)sendMail:(id)sender{
	[self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([restaurantEmail.text isEqualToString:@""]) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Email Address!! " message:@"Sorry!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return;
	}
	
	NSString *subject = [NSString stringWithString:@"Feedback for Dubai Hotel List version 0.2"];
	NSString *emailId = restaurantEmail.text;
	NSString *emailIDString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
							   [emailId stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							   [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailIDString]])
	{
		// there was an error trying to open the URL.
		//for the time being we'll ignore it.
	}	
}





/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Map"
																			   style:UIBarButtonItemStylePlain 
																			  target:self
																			  action:@selector(openMap:)]autorelease];
	
self.title = @"RestaurantDetails";
	[self populateData];

}

#pragma mark -
#pragma mark populating Data 
-(void)populateData{
	
	NSLog(@"In Fetch data method...");
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSEntityDescription *entityDescriptionDepartment = [NSEntityDescription entityForName:@"Restaurant" inManagedObjectContext:context];
	NSFetchRequest *requestDepartment = [[[NSFetchRequest alloc] init] autorelease];
	[requestDepartment setEntity:entityDescriptionDepartment];
	NSPredicate *predicate= [NSPredicate predicateWithFormat: @"(restaurantName == %@)",selectedRestaurantName];
	[requestDepartment setPredicate:predicate];
	
	
	
	NSSortDescriptor *sortDescriptorDepartment = [[NSSortDescriptor alloc] initWithKey:@"restaurantName" ascending:YES];
	[requestDepartment setSortDescriptors:[NSArray arrayWithObject:sortDescriptorDepartment]];
	
	NSError *error;
	NSArray *arrayDepartment = [context executeFetchRequest:requestDepartment error:&error];
	[sortDescriptorDepartment release];
	
	Restaurants *obj;
	obj = [arrayDepartment objectAtIndex:index];
		
		
		restaurantName.text = [obj valueForKey:@"restaurantName"];
		
		restaurantAddress.text = [obj valueForKey:@"restaurantAddress"];
		restaurantTelephoneNo.text = [obj valueForKey:@"restaurantTelephone"];
		restaurantWebsite.text = [obj valueForKey:@"restaurantWebsite"];
		restaurantEmail.text = [obj valueForKey:@"restaurantEmail"];
		restaurantCity.text = [obj valueForKey:@"restaurantCity"];
	
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
	NSLog(@"Path --> %@",storeUrl);
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
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
	[restaurantName release];
	[restaurantAddress release];
	[restaurantTelephoneNo release];
	[restaurantWebsite release];
	[restaurantEmail release];
	[restaurantCity release];
	
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	
	[super dealloc];
}


@end
