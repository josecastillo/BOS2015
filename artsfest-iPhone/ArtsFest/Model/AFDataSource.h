//
//  AFDataSource.h
//  ArtsFest
//
//  Created by Jose Castillo on 5/11/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFDataSource : NSObject <UIAlertViewDelegate> {
	NSArray *resourceTypes;
	int currentFeed;
	NSMutableDictionary *artists;
	NSMutableDictionary *categories;
	NSMutableDictionary *venues;
	NSDateFormatter *dateFormatter;
	NSDateFormatter *dateSortFormatter;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)loadData;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (AFDataSource *)defaultSource;

@end
