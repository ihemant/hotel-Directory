
@class HotelDetail;
#import <UIKit/UIKit.h>
#import<CoreData/CoreData.h>
@class MapKitDisplayViewController;
@class MapViewController;
@interface DubaiHotelDirectoryAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	UINavigationController *navigationController;
	UIWindow *window;
    UITabBarController *tabBarController;
	MapKitDisplayViewController *viewController;
	MapViewController *mapViewController;
	HotelDetail *hotelDetail;

}
@property (nonatomic, retain) IBOutlet HotelDetail *hotelDetail;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet MapKitDisplayViewController *viewController;

- (NSString *)applicationDocumentsDirectory;
-(void)createEditableCopyDatabaseIfNeeded;

@end
