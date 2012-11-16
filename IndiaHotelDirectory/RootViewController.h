//
//  TypeViewController.h
//  DubaiHotelDirectory
//
//  Created by hemant kumar on 10/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface RootViewController : UITableViewController<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray *types;
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSFetchedResultsController *fetchedResultsController;
	NSMutableArray *ratingArray;
	NSMutableArray *contentRating;
	NSString *selectedRestaurantCuisine;
	
}
@property (nonatomic, retain) NSString * selectedRestaurantCuisine;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSMutableArray *ratingArray;
@property (nonatomic, retain) NSMutableArray *contentRating;
- (NSString *)applicationDocumentsDirectory;
-(IBAction)aroundMe:(id)sender;
@end
