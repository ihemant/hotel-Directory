
#import "RSGAroundMeEventView.h"


@implementation RSGAroundMeEventView
- (id)initWithAnnotation:(id <MKAnnotation>)annotation 
         reuseIdentifier:(NSString *)reuseIdentifier {
	if(self = [super initWithAnnotation:annotation 
						reuseIdentifier:reuseIdentifier]) {
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation {
	super.annotation = annotation;
	if([annotation isMemberOfClass:[RSGEvent class]]) {
		event = (RSGEvent *)annotation;
		float magSquared = event.magnitude * event.magnitude;
		self.frame = CGRectMake(0, 0, magSquared * .75,  magSquared * .75);
	} else {
		self.frame = CGRectMake(0,0,0,0);
	}
	
}

- (void)drawRect:(CGRect)rect {
	float magSquared = event.magnitude * event.magnitude;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(context, 1.0, 1.0 - magSquared * 0.015, 0.211, .6);
	CGContextFillEllipseInRect(context, rect);
}

- (void)dealloc {
	[event release];
	[super dealloc];
}

@end
