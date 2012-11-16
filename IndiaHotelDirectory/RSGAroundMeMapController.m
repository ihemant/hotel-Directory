
#import "RSGAroundMeMapController.h"
#import "RSGEvent.h"
#import "RSGAroundMeEventView.h"



@implementation RSGAroundMeMapController
@synthesize locationNames, addresses, fetchedResultsController, managedObjectContext, searchBy;


- (void)viewDidLoad {
	[super viewDidLoad];
	
	eventPoints = [[NSMutableArray array] retain];
	RSGEvent *event;
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Handle the error...
	}
	
	NSString *urlString;
	NSString *locationString;
	NSArray *listItems;
	for(int i =0 ; i< [locationNames count] && i <= 100; i++){
		event = [[[RSGEvent alloc] init] autorelease];
		
		//***** Getting long and lat from location name
		urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&near=India&output=csv", 
							   [[locationNames objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSError *error;
		locationString = [NSString
									stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding 
									error:&error];
		listItems = [locationString componentsSeparatedByString:@","];
		double latitude = 0.0;
		double longitude = 0.0;
		
		if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
			latitude = [[listItems objectAtIndex:2] doubleValue];
			longitude = [[listItems objectAtIndex:3] doubleValue];
		}
		else {
			//Show error
		}
		

		//*****

		event.latitude = latitude;//25.249843;
		event.longitude = longitude;//55.280249;

		event.mTitle = [addresses objectAtIndex:i];
		event.mSubTitle = [locationNames objectAtIndex:i];
		//NSLog(@"\n%d. latitude -> %f\tlongitude -> %f ",i,latitude,longitude);

		event.magnitude = 22;
		event.depth = 11;
		[eventPoints addObject:event];
		
		if(i == 100) {
			//limit number of events to 300
			break;
		}
	}//for loop
	
	CLLocation *userLoc = [[mapView userLocation] location];
	CLLocationCoordinate2D userCoords = [userLoc coordinate];
	userCoords.longitude = 77.169385; //FOR INDIA
	userCoords.latitude = 28.718104;
	
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userCoords, 30000, 30000);
	[mapView setRegion:region animated:YES];
	
	
	
	[mapView addAnnotations: eventPoints];

	

	//[mapView setShowsUserLocation:YES];
	mapView.showsUserLocation=TRUE;

	
	[segmentController addTarget:self
						  action:@selector(segmentControllerAction:)
				forControlEvents:UIControlEventValueChanged];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentController];
}



- (MKAnnotationView *)mapView:(MKMapView *)lmapView 
            viewForAnnotation:(id <MKAnnotation>)annotation {
	

	RSGAroundMeEventView *eventView = (RSGAroundMeEventView *)[lmapView 
															 dequeueReusableAnnotationViewWithIdentifier:
															 @"eventview"];
	if(eventView == nil) {
		eventView = [[[RSGAroundMeEventView alloc] initWithAnnotation:annotation 
													 reuseIdentifier:@"eventview"] 
					 autorelease];
	}
	eventView.annotation = annotation;
	return eventView;
}

//For segment Controller

-(IBAction)segmentControllerAction:(id)sender{
	if(segmentController.selectedSegmentIndex == 0){
		mapView.mapType = MKMapTypeSatellite;	
	}
	else if(segmentController.selectedSegmentIndex == 1){
		mapView.mapType = MKMapTypeStandard;	
		
	}
	else if(segmentController.selectedSegmentIndex == 2){
		mapView.mapType = MKMapTypeHybrid;	
		
	}
}



#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    NSEntityDescription *entityDescriptionDepartment = [NSEntityDescription entityForName:@"Hotels" inManagedObjectContext:[self managedObjectContext]];
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:entityDescriptionDepartment];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hotelName" ascending:YES];
	
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	
	//*******
	
	NSError *error;
	NSArray *array = [[self managedObjectContext]  executeFetchRequest:fetchRequest error:&error];
	
	if([array count]>0){
		
		NSEnumerator *e = [array objectEnumerator];
		id obj;
		locationNames = [[[NSMutableArray alloc] init] retain];
		addresses = [[[NSMutableArray alloc] init] retain];

		
		while ((obj = [e nextObject]) != nil) {
			
			if([[obj valueForKey:@"hotelAddress"] length]== 1){
				[locationNames addObject:[obj valueForKey:@"hotelAddress"]];	
			}
			else {
				[locationNames addObject:[obj valueForKey:@"hotelAddress"]];	
			}		
			[addresses addObject:[obj valueForKey:@"hotelAddress"]];	

		}//while
		
	}//if
			
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
	
	
	aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release];
	[sortDescriptor release];
	[fetchRequest release];
	[entityDescriptionDepartment release];
	
	return fetchedResultsController;
}    


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	// Override point for customization after app launch    
	
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


- (void)dealloc {
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
	[locationNames release];
	[addresses release];
	
	[eventPoints release];
	[super dealloc];
}

@end
