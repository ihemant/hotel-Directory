

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface RestaurantDetailView : UIViewController {
	UILabel *restaurantName;
	UITextView *restaurantAddress;
	UILabel *restaurantCity;
	UILabel *restaurantTelephoneNo;
	UILabel *restaurantWebsite;
	UILabel *restaurantEmail;
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	NSUInteger *index;
	
	NSString *selectedRestaurantName;


}
@property (nonatomic, retain) NSString * selectedRestaurantName;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,assign) IBOutlet NSUInteger *index;

@property (nonatomic,retain) IBOutlet UILabel *restaurantName;
@property (nonatomic,retain) IBOutlet UITextView *restaurantAddress;
@property (nonatomic,retain) IBOutlet UILabel *restaurantCity;
@property(nonatomic,retain)IBOutlet UILabel *restaurantWebsite;
@property(nonatomic,retain)IBOutlet UILabel *restaurantTelephoneNo;

@property(nonatomic,retain)IBOutlet UILabel *restaurantEmail;
-(void)populateData;
-(IBAction)openBrowser:(id)sender;
-(IBAction)sendMail:(id)sender;
-(IBAction)makeCall:(id)sender;
-(IBAction)openMap:(id)sender;

- (NSString *)applicationDocumentsDirectory;


@end
