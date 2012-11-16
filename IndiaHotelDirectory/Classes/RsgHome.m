//
//  RsgHome.m
//  HotelListAndRestaurant
//
//  Created by hemant kumar on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RsgHome.h"
#import "WebsiteViewController.h"


@implementation RsgHome
-(IBAction)openFeedback:(id)sender{
	NSString *subject = [NSString stringWithString:@"Feedback for  Hotel List version 1.0"];
	NSString *emailIDString = [NSString stringWithFormat:@"mailto:?to=feedback@rsgss.com&subject=%@",
							   [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	
	if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailIDString]])
	{
		// there was an error trying to open the URL.
		//for the time being we'll ignore it.
	}
}
-(IBAction)openWebsite:(id)sender
{ 
	NSLog(@"checking22222-----");
	WebsiteViewController *websiteView = [[WebsiteViewController alloc] initWithNibName:@"WebsiteViewController" bundle:nil];
	NSString *urlAddress = @"http://www.rsg.co.in";
	websiteView.urlAddress = urlAddress;
	//[self.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController pushViewController:websiteView animated:YES];
	
	}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES]; 
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title =@"About";
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
}


@end
