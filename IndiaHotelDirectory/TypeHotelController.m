
#import "TypeHotelController.h"
#import "RSGHotellCustomCell.h";
#import "HotelDetail.h"
#import "MapViewController.h"
#import "Hotels.h"
#import "RSGAroundMeMapController.h"
#import "WebsiteViewController.h"
@implementation TypeHotelController

@synthesize mainTableView;
@synthesize contentsList, contentsList1;
@synthesize searchResults;
@synthesize savedSearchTerm;
@synthesize managedObjectContext,fetchedResultsController, dataArray, dataArray1, searchBy,selectedHotelRating;
-(IBAction)aroundMe:(id)sender{
	RSGAroundMeMapController *mapController = [[RSGAroundMeMapController alloc] initWithNibName:@"RSGAroundMeMapController" bundle:nil];
	[self.navigationController pushViewController:mapController animated:YES];
	[mapController release];
	
}

- (void)dealloc
{
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	[dataArray release] ,dataArray = nil;
	[dataArray1 release], dataArray1 = nil;
	[contentsList1 release], contentsList1 = nil;
	[searchBy release] ,searchBy = nil;

	[mainTableView release], mainTableView = nil;
	[contentsList release], contentsList = nil;
	[searchResults release], searchResults = nil;
	[savedSearchTerm release], savedSearchTerm = nil;
	
    [super dealloc];
	
}

- (void)viewDidUnload
{
	
	[super viewDidUnload];
	
	// Save the state of the search UI so that it can be restored if the view is re-created.
	[self setSavedSearchTerm:[[[self searchDisplayController] searchBar] text]];
	
	[self setSearchResults:nil];
	
}

- (void)viewDidLoad
{
	
    [super viewDidLoad];
	for (UIView *searchBarSubview in [searchBar subviews]) {
		if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
			@try {
				[(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
			}
			@catch (NSException * e) {
				// ignore exception
			}
		}
	}
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"around Me"
																			   style:UIBarButtonItemStylePlain 
																			  target:self
																			  action:@selector(aroundMe:)]autorelease];
	self.title = @"Hotels";
	[searchBar setSelectedScopeButtonIndex:0];
	self.mainTableView.rowHeight = 60;
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Handle the error...
	}
	[contentsList release], contentsList =nil;
	[contentsList1 release], contentsList1 = nil;
	[searchBy release], searchBy = nil;
	self.searchBy = @"name";
	NSMutableArray *array = [[NSMutableArray alloc] initWithArray:dataArray];
	NSMutableArray *array1 = [[NSMutableArray alloc] initWithArray:dataArray1];
	[self setContentsList:array];
	[self setContentsList1:array1];
	[array release], array = nil;
	[array1 release], array1 = nil;
	
	
	// Restore search term
	if ([self savedSearchTerm])
	{
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
    }
	
	}

- (void)viewWillAppear:(BOOL)animated
{
	
    [super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO]; 
	[[self mainTableView] reloadData];
	
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

- (void)handleSearchForTerm:(NSString *)searchTerm
{
	
	[self setSavedSearchTerm:searchTerm];
	
	if ([self searchResults] == nil)
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[self setSearchResults:array];
		[array release], array = nil;
	}
	
	[[self searchResults] removeAllObjects];
	
	if ([[self savedSearchTerm] length] != 0)
	{
		for (NSString *currentString in [self contentsList])
		{
			if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
			{
				[[self searchResults] addObject:currentString];
			}
		}
	}
	
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	
	NSInteger rows;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView])
		rows = [[self searchResults] count];
	else
		rows = [[self contentsList] count];
	
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSInteger row = [indexPath row];
	NSString *contentForThisRow = nil;
	
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	
	RSGHotellCustomCell *cell = (RSGHotellCustomCell  *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil)
	{
		
		NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"RSGHotellCustomCell" owner:nil options:nil];
		
		
		for(id currentCell in cells) {
			
			
			if([currentCell isKindOfClass:[RSGHotellCustomCell class]]) {
				
				cell = (RSGHotellCustomCell *)currentCell;
				
				break;
				
			}
		}
		
	}	
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	//For by name
	if([searchBy isEqualToString:@"name"]){
		
		
		if (tableView == [[self searchDisplayController] searchResultsTableView]){
			int rowNumber = [contentsList indexOfObjectIdenticalTo:[searchResults objectAtIndex:indexPath.row]];
			NSManagedObject *hotels= [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
			
			cell.name.text = [hotels valueForKey:@"hotelName"];
			
			if ([[hotels valueForKey:@"hotelAddress"] length] == 1) {
				cell.location.text = [hotels valueForKey:@"hotelAddress"];
				
			}
			else {
				cell.location.text = [hotels valueForKey:@"hotelAddress"];
				
			}
			
			cell.mapView.tag = rowNumber;
			cell.website.tag = rowNumber;
			cell.telephone.tag = rowNumber;
			cell.email.tag = rowNumber;
			
		}
		else{
			contentForThisRow = [[self contentsList] objectAtIndex:row];
			cell.name.text = contentForThisRow;
			cell.location.text = [[self contentsList1] objectAtIndex:row];
			cell.mapView.tag = indexPath.row;
			cell.website.tag = indexPath.row;
			cell.telephone.tag = indexPath.row;
			cell.email.tag = indexPath.row;
			
		}//else
	}//outer if
	
	//For By Location
	else {
		if (tableView == [[self searchDisplayController] searchResultsTableView]){
			int rowNumber = [contentsList indexOfObjectIdenticalTo:[searchResults objectAtIndex:indexPath.row]];
			NSManagedObject *hotels = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
			
			if ([[hotels valueForKey:@"hotelAddress"] isEqualToString:@"-"]) {
				cell.name.text = [hotels valueForKey:@"hotelAddress"];
				
			}
			else {
				cell.name.text = [hotels valueForKey:@"hotelAddress"];
				
			}
			
			cell.location.text = [hotels valueForKey:@"hotelName"];
			
			cell.mapView.tag = rowNumber;
			cell.website.tag = rowNumber;
			cell.telephone.tag = rowNumber;
			cell.email.tag = rowNumber;
		}// Inner if
	    else{
			contentForThisRow = [[self contentsList] objectAtIndex:row];
			cell.name.text = contentForThisRow;
			cell.location.text = [[self contentsList1] objectAtIndex:row];
			cell.mapView.tag = indexPath.row;
			cell.website.tag = indexPath.row;
			cell.telephone.tag = indexPath.row;
			cell.email.tag = indexPath.row;
		}//else
	}//outer else
	
	[cell.mapView addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
	[cell.website addTarget:self action:@selector(showWeb:) forControlEvents:UIControlEventTouchUpInside];
	[cell.telephone addTarget:self action:@selector(makeCall:) forControlEvents:UIControlEventTouchUpInside];
	[cell.email addTarget:self action:@selector(sendMail:) forControlEvents:UIControlEventTouchUpInside];

	NSString *path =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"maps.png"];
	
	[cell.image setImage:[[UIImage alloc] initWithContentsOfFile:path]];
	NSManagedObject *hotels = [fetchedResultsController objectAtIndexPath:indexPath];
NSString *path1 =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"starOn.png"];
			

	if([[hotels valueForKey:@"rating"]intValue]==1){
	    [cell.image1 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];
	}
	else if([[hotels valueForKey:@"rating"]intValue]==2)
	{ [cell.image1 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];
		
		[cell.image2 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];
	}
	else if([[hotels valueForKey:@"rating"]intValue]==3){
		[cell.image1 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];
		
		[cell.image2 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];	
		[cell.image3 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];
	}
	else if([[hotels valueForKey:@"rating"]intValue]==4){
		[cell.image1 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];
		
		[cell.image2 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];	
		[cell.image3 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];
		[cell.image4 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];
	}
	else{
		[cell.image1 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];
		[cell.image2 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];	
		[cell.image3 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];
		[cell.image4 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];
		[cell.image5 setImage:[[UIImage alloc]initWithContentsOfFile:path1]];
	}
	return cell;
}

	
//For sending mail
-(IBAction)sendMail:(id)sender{
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	NSManagedObject *object = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    if ([[object valueForKey:@"hotelEmail"] length] == 1) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Email Address!! " message:@"Sorry!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return;
	}
	
	NSString *subject = [NSString stringWithString:@"Feedback for Dubai Hotel List version 0.2"];
	NSString *emailId = [object valueForKey:@"hotelEmail"];
	NSString *emailIDString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
							   [emailId stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
							   [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailIDString]])
	{
		// there was an error trying to open the URL.
		//for the time being we'll ignore it.
	}	
}

//For Calling
-(IBAction)makeCall:(id)sender{
	NSManagedObject *object = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    if ([[object valueForKey:@"hotelTelephone"] length] == 1) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Telephone Number Available!! " message:@"Sorry!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		
		return;
	}
	
	NSString *callToURLString = [NSString stringWithFormat:@"tel:%@",[object valueForKey:@"hotelTelephone"]];
	
	if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:callToURLString]])
	{
		// there was an error trying to open the URL.
		//for the time being we'll ignore it.
	}
	
}



//For Opening Website
-(IBAction)showWeb:(id)sender{
	NSManagedObject *object = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    WebsiteViewController *websiteView = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
	if ([[object valueForKey:@"hotelWebsite"] isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Website Address Available!! " message:@"Sorry!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	
	NSString *urlAddress = [NSString stringWithFormat:@"http://%@",[object valueForKey:@"hotelWebsite"]];
	websiteView.urlAddress = urlAddress;
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController pushViewController:websiteView animated:YES];
	
}

//For map
-(IBAction)showMap:(id)sender{
	NSManagedObject *object = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
	MapViewController *mapController = [[MapViewController alloc] initWithNibName:@"MapView" bundle:nil];
	if ([[object valueForKey:@"hotelAddress"] length] == 1) {
		mapController.location1 = [object valueForKey:@"hotelAddress"];
		mapController.mapSubTitle = [object valueForKey:@"hotelAddress"];

	}
	else {
		mapController.location1 = [object valueForKey:@"hotelAddress"];
		mapController.mapSubTitle = [object valueForKey:@"hotelAddress"];
}
	mapController.mapTitle = [object valueForKey:@"hotelName"];
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController pushViewController:mapController animated:YES];
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	HotelDetail *hotelDetail = [[HotelDetail alloc] initWithNibName:@"HotelDetail" bundle:nil];
	
	if (tableView == [[self searchDisplayController] searchResultsTableView]){
		int rowNumber = [contentsList indexOfObjectIdenticalTo:[searchResults objectAtIndex:indexPath.row]];
		NSManagedObject *hotels = [fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
		hotelDetail.selectedHotelName = [hotels valueForKey:@"hotelName"];
	}
	
	else {
		NSManagedObject *hotels = [fetchedResultsController objectAtIndexPath:indexPath];
		hotelDetail.selectedHotelName = [hotels valueForKey:@"hotelName"];
	}
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	[self.navigationController pushViewController:hotelDetail animated:YES];
	[hotelDetail release];
	
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods
//Calling searchByName;

- (void) searchBar:(UISearchBar*) searchBar1 selectedScopeButtonIndexDidChange:(NSInteger) selectedScope {
	
	if(selectedScope == 0){//SearchByLocation
		
		searchBar1.text = @"";
		
		[contentsList release], contentsList =nil;
		[contentsList1 release], contentsList1 = nil;
		[searchBy release], searchBy = nil;
		
		self.searchBy = @"name";
		
		NSMutableArray *array = [[NSMutableArray alloc] initWithArray:dataArray];
		NSMutableArray *array1 = [[NSMutableArray alloc] initWithArray:dataArray1];
		
		[self setContentsList:array];
		[self setContentsList1:array1];
		
		[array release], array = nil;
		[array1 release], array1 = nil;
		
		// Restore search term
		if ([self savedSearchTerm])
		{
			[[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
		}
		
		[[self mainTableView] reloadData];	
	}//if
	
	//SearchByLocation
	else if(selectedScope == 1){
		
		searchBar1.text = @"";
		[contentsList release], contentsList =nil;
		[contentsList1 release], contentsList1 = nil;
		[searchBy release], searchBy = nil;
		
		self.searchBy = @"hotelAddress";
		
		NSMutableArray *array = [[NSMutableArray alloc] initWithArray:dataArray];
		NSMutableArray *array1 = [[NSMutableArray alloc] initWithArray:dataArray1];
		
		[self setContentsList:array1];
		[self setContentsList1:array];
		
		[array release], array = nil;
		[array1 release], array1 = nil;
		
		
		// Restore search term
		if ([self savedSearchTerm])
		{
			[[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
		}
		
		[[self mainTableView] reloadData];
		
		
	}//if
}



- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
	
	[self handleSearchForTerm:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	
	[self setSavedSearchTerm:nil];
	
	[[self mainTableView] reloadData];
	
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
	NSPredicate *predicate;
	if ([selectedHotelRating isEqualToString:@"1 Star"]) {
		predicate = [NSPredicate predicateWithFormat: @"(rating == '1')"];
		
	}
	else if([selectedHotelRating isEqualToString:@"2 Star"]) {
		predicate = [NSPredicate predicateWithFormat: @"(rating == '2')"];
		
	}
	else if([selectedHotelRating isEqualToString:@"3 Star"]) {
		predicate = [NSPredicate predicateWithFormat: @"(rating == '3')"];
		
	}
	else if([selectedHotelRating isEqualToString:@"4 Star"]) {
		predicate = [NSPredicate predicateWithFormat: @"(rating == '4')"];
		
	}
	else if([selectedHotelRating isEqualToString:@"5 Star"]) {
		predicate = [NSPredicate predicateWithFormat: @"(rating == '5')"];
		
	}
	else if([selectedHotelRating isEqualToString:@"6 Star"]) {
		predicate = [NSPredicate predicateWithFormat: @"(rating == '6')"];
		
	}
	else if([selectedHotelRating isEqualToString:@"7 Star"]) {
		predicate = [NSPredicate predicateWithFormat: @"(rating == '7')"];
		
	}
	
	else {
		[selectedHotelRating isEqualToString:@"Resorts"]; 
		predicate = [NSPredicate predicateWithFormat: @"(rating == '8')"];
		
	}
	
	[fetchRequest setPredicate:predicate];
	
	
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hotelName" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	//*******
	
	NSError *error;
	NSArray *array = [[self managedObjectContext]  executeFetchRequest:fetchRequest error:&error];
	
	if([array count]>0){
		
		NSEnumerator *e = [array objectEnumerator];
		id obj;
		dataArray = [[[NSMutableArray alloc] init] retain];
		dataArray1 = [[[NSMutableArray alloc] init] retain];
		
		while ((obj = [e nextObject]) != nil) {
			[dataArray addObject:[obj valueForKey:@"hotelName"]];
			
			if([[obj valueForKey:@"hotelAddress"] length]== 1){
				[dataArray1 addObject:[obj valueForKey:@"hotelAddress"]];	
			}
			else {
				[dataArray1 addObject:[obj valueForKey:@"hotelAddress"]];	
			}			
		}//while
		
	}//if
	
	//*******
	
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
	
	
	aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release];
	[predicate release];
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




@end
