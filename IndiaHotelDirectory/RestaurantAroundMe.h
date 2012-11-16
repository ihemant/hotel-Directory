
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
@interface RestaurantAroundMe : UIViewController <MKMapViewDelegate, NSFetchedResultsControllerDelegate,CLLocationManagerDelegate> {
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSFetchedResultsController *fetchedResultsController;
	
	NSMutableArray *locationNames;
	NSMutableArray *addresses;

	NSString *searchBy;
	
	IBOutlet MKMapView *mapView;
	NSMutableArray *eventPoints;
	IBOutlet UISegmentedControl *segmentController;

	
}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) NSString *searchBy;

-(NSString *)applicationDocumentsDirectory;

@property (nonatomic, retain) NSMutableArray *locationNames;
@property (nonatomic, retain) NSMutableArray *addresses;

-(IBAction)segmentControllerAction:(id)sender;
@end
