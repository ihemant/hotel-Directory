//
//  WebsiteViewController.h
//  DubaiHotelDirectory
//
//  Created by hemant kumar on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebsiteViewController : UIViewController<UIWebViewDelegate> {
	IBOutlet UIWebView *websiteView;
	NSString *urlAddress;
	IBOutlet UIActivityIndicatorView *activityIndicator;	

}
@property (nonatomic, retain) IBOutlet UIWebView *websiteView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) NSString *urlAddress;

@end
