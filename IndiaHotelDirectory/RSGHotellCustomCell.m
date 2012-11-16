
#import "RSGHotellCustomCell.h"
@implementation RSGHotellCustomCell

@synthesize image, name,location, email, telephone, website, mapView,rating1;
@synthesize image1,image2,image3,image4,image5;

/*- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}
 */

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)viewDidLoad
{    
}
 
- (void)viewDidUnload {
    
}




- (void)dealloc {
	[image release];
	[name release];
	[location release];
	[email release];
	[telephone release];
	[website release];
	[rating1 release];
    [super dealloc];
}


@end
