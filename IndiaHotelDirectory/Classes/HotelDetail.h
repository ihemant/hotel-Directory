
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RateView.h"

@interface HotelDetail : UIViewController<RateViewDelegate> {
	NSUInteger *index;

	UILabel *hotelName;
	UITextView *hotelAddress;
	UILabel *hotelTelephone;
	UILabel *hotelFax;
	UILabel *hotelWebsite;
	UILabel *hotelEmail;
	UILabel *hotelCity;
	UILabel *longitude;
	UILabel *latitude;
    //UILabel *rating;
	
	NSString *selectedHotelId;
	NSString *selectedHotelName;
	
	NSString *websiteAddress;

	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	RateView *_rateView;
    UILabel *_statusLabel;
	UIImageView *image0;
}
//@property (nonatomic, retain) IBOutlet UILabel *rating;

@property (nonatomic, retain) NSString * selectedHotelId;
@property (nonatomic, retain) NSString * selectedHotelName;
@property (nonatomic, retain) IBOutlet UILabel *longitude;
@property (nonatomic, retain) IBOutlet UILabel *latitude;
@property (nonatomic, retain) IBOutlet UIImageView *image0;


@property (retain) IBOutlet RateView *rateView;
@property (retain) IBOutlet UILabel *statusLabel;

@property (nonatomic,assign) IBOutlet NSUInteger *index;
@property (nonatomic,retain) NSString *websiteAddress;
//@property (nonatomic,retain) IBOutlet 	UILabel *hotelLocation;

@property (nonatomic,retain) IBOutlet 	UILabel *hotelName;
@property (nonatomic,retain) IBOutlet 	UITextView *hotelAddress;
@property (nonatomic,retain) IBOutlet 	UILabel *hotelTelephone;
@property (nonatomic,retain) IBOutlet 	UILabel *hotelFax;
@property (nonatomic,retain) IBOutlet 	UILabel *hotelWebsite;
@property (nonatomic,retain) IBOutlet 	UILabel *hotelEmail;
@property (nonatomic,retain) IBOutlet 	UILabel *hotelCity;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSString *)applicationDocumentsDirectory;
-(void)detailView;
-(IBAction)openBrowser:(id)sender; 
-(IBAction)openMap:(id)sender;
-(IBAction)makeCall:(id)sender;
-(IBAction)sendMail:(id)sender;


@end
