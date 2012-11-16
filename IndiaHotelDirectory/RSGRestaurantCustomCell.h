
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface RSGRestaurantCustomCell : UITableViewCell {
	IBOutlet UIImageView *image;
	IBOutlet UILabel *name;
	IBOutlet UILabel *location;
	IBOutlet UIButton *email;
	IBOutlet UIButton *telephone;
	IBOutlet UIButton *website;
	
	IBOutlet UIButton *mapView;
}

@property (nonatomic, retain) IBOutlet UIImageView *image;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *location;
@property (nonatomic, retain) IBOutlet UIButton *email;
@property (nonatomic, retain) IBOutlet UIButton *telephone;
@property (nonatomic, retain) IBOutlet UIButton *website;
@property (nonatomic, retain) IBOutlet UIButton *mapView;






@end
