//
//  WebsiteViewController.m
//  DubaiHotelDirectory
//
//  Created by hemant kumar on 10/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebsiteViewController.h"


@implementation WebsiteViewController
@synthesize websiteView,urlAddress,activityIndicator;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO]; 
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSURL *url = [NSURL URLWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[websiteView loadRequest:requestObj];
	websiteView.scalesPageToFit = YES;
	websiteView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self webViewDidStartLoad:websiteView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {  
	
	activityIndicator.hidden= TRUE;     
	[activityIndicator stopAnimating];  
}

- (void)webViewDidStartLoad:(UIWebView *)webView {  
	activityIndicator.hidden= FALSE;    
	[activityIndicator startAnimating];     
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

- (void)viewDidUnload {
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
	[websiteView release];
	[urlAddress release];
	[activityIndicator release];
}


@end
