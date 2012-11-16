
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TypeHotelController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSFetchedResultsController *fetchedResultsController;

	NSMutableArray *dataArray;
	NSMutableArray *dataArray1;
	NSMutableArray *contentsList1;
	
	IBOutlet UISearchBar *searchBar;
	NSString *searchBy;

	UITableView *mainTableView;
	
	NSMutableArray *contentsList;
	NSMutableArray *searchResults;
	NSString *savedSearchTerm;
	NSString *selectedHotelRating;

}
@property (nonatomic, retain) NSString * selectedHotelRating;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *dataArray1;
@property (nonatomic, retain) NSMutableArray *contentsList1;

@property (nonatomic, retain) NSString *searchBy;


@property (nonatomic, retain) IBOutlet UITableView *mainTableView;
@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;

- (void)handleSearchForTerm:(NSString *)searchTerm;

-(NSString *)applicationDocumentsDirectory;

-(IBAction)showMap:(id)sender;
-(IBAction)showWeb:(id)sender;
-(IBAction)makeCall:(id)sender;
-(IBAction)sendMail:(id)sender;
-(IBAction)aroundMe:(id)sender;

@end
