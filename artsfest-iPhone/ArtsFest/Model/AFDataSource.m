//
//  AFDataSource.m
//  ArtsFest
//
//  Created by Jose Castillo on 5/11/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFDataSource.h"

@implementation AFDataSource

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static AFDataSource *instance;

+ (AFDataSource *)defaultSource {
	if (!instance) {
		instance = [[AFDataSource alloc] init];
	}
	
	return instance;
}

- (id)init {
	self = [super init];
	if (self) {
		resourceTypes =
		@[
			 @{
				@"endpoint":@"artists",
				@"entityName":@"AFArtist"
			  },
			 @{
				@"endpoint":@"venues",
				@"entityName":@"AFVenue"
			  },
			 @{
				@"endpoint":@"categories",
				@"entityName":@"AFCategory"
			  },
			 @{
				@"endpoint":@"events",
				@"entityName":@"AFEvent"
			  },
			@{
				@"endpoint":@"sponsors",
				@"entityName":@"AFSponsor"
			  }
		 ];
		currentFeed = 0;
		artists = [NSMutableDictionary dictionary];
		categories = [NSMutableDictionary dictionary];
		venues = [NSMutableDictionary dictionary];
		
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:@"US/Eastern"];
		dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		[dateFormatter setDateFormat:@"EEEE, MMM d"];

		dateSortFormatter = [[NSDateFormatter alloc] init];
		dateSortFormatter.timeZone = [[NSTimeZone alloc] initWithName:@"US/Eastern"];
		dateSortFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		[dateSortFormatter setDateFormat:@"yyyyMMdd"];
    }
	return self;
}

- (void)loadNextFeed {
	static float overallProgress = 0.0;
	NSDictionary *resourceDescriptor = resourceTypes[currentFeed];
	NSError *error;
	NSString *endpoint = resourceDescriptor[@"endpoint"];
	NSString *entityName = resourceDescriptor[@"entityName"];
	NSString *lastUpdatedKey = [entityName stringByAppendingString:@"LastUpdated"];
	NSNumber *lastUpdated = [[NSUserDefaults standardUserDefaults] valueForKey:lastUpdatedKey];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://bos2014.herokuapp.com/%@.json?updated_since=%.0f", endpoint, [lastUpdated doubleValue]]];
	dispatch_sync(dispatch_get_main_queue(), ^{[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];});
	NSData *data = [[NSData alloc] initWithContentsOfURL:url];
	dispatch_sync(dispatch_get_main_queue(), ^{[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];});
	if (!data) {
		if (lastUpdated) {
			// If we already have data, go ahead and move on to the next feed. 
			currentFeed++;
			overallProgress += 0.2;
			if (currentFeed < 5) {
				[self loadNextFeed];
			} else {
				[[NSNotificationCenter defaultCenter] postNotificationName:@"AFProgressComplete"
																	object:self
																  userInfo:nil];
			}
		} else {
			// If we haven't loaded data before, we can't proceed.
			dispatch_sync(dispatch_get_main_queue(), ^{
				[[[UIAlertView alloc] initWithTitle:@"Unable to load schedule"
											message:@"Please check your internet connection and try again."
										   delegate:self
								  cancelButtonTitle:nil
								  otherButtonTitles:@"Try Again", nil] show];
			});
		}
		
		// Either way, return at the end since there's nothing left to do for this feed. 
		return;
	}
	NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if (response) {
		NSArray *result = response[@"result"];
		NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
		NSDictionary *properties = [entity propertiesByName];
		int numResults = [result count];
		int processed = 0;
		__block double latestObjectTimestamp = 0;
		__block NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
		__block NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == $IDENTIFIER"];
		__block NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:1];
		for (NSDictionary *sourceObject in result) {
			dispatch_sync(dispatch_get_main_queue(), ^{
				NSNumber *identifier = [sourceObject objectForKey:@"id"];
				[variables setObject:identifier forKey:@"IDENTIFIER"];
				request.predicate = [predicate predicateWithSubstitutionVariables:variables];
				NSManagedObject *destinationObject = [[self.managedObjectContext executeFetchRequest:request error:NULL] lastObject];
				if (!destinationObject) {
					destinationObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
					[destinationObject setValue:identifier forKey:@"id"];
				}
				[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
				double objectTimestamp = [[sourceObject valueForKey:@"last_modified"] doubleValue];
				if (objectTimestamp > latestObjectTimestamp)
					latestObjectTimestamp = objectTimestamp;
				for (NSString *key in sourceObject) {
					id value = sourceObject[key];
					id property = properties[key];
					if ([property isKindOfClass:[NSRelationshipDescription class]]) {
						if ([key isEqualToString:@"artists"]) {
							NSMutableSet *set = [destinationObject mutableSetValueForKey:key];
							for (NSNumber *identifier in value) {
								NSManagedObject *object = artists[identifier];
								if (!object) {
									NSFetchRequest *subrequest = [[NSFetchRequest alloc] initWithEntityName:@"AFArtist"];
									[subrequest setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"id", identifier]];
									object = [[self.managedObjectContext executeFetchRequest:subrequest
																					   error:NULL] lastObject];
								}
								if (object)
									[set addObject:object];
							}
						}
						if ([key isEqualToString:@"categories"]) {
							NSMutableSet *set = [destinationObject mutableSetValueForKey:key];
							for (NSNumber *identifier in value) {
								NSManagedObject *object = categories[identifier];
								if (!object) {
									NSFetchRequest *subrequest = [[NSFetchRequest alloc] initWithEntityName:@"AFCategory"];
									[subrequest setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"id", identifier]];
									object = [[self.managedObjectContext executeFetchRequest:subrequest
																					   error:NULL] lastObject];
								}
								if (object)
									[set addObject:object];
							}
						}
						if ([key isEqualToString:@"venue"]) {
							NSNumber *identifier = [sourceObject valueForKey:@"venue"];
							NSManagedObject *object = venues[identifier];
							if (!object) {
								NSFetchRequest *subrequest = [[NSFetchRequest alloc] initWithEntityName:@"AFVenue"];
								[subrequest setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"id", identifier]];
								object = [[self.managedObjectContext executeFetchRequest:subrequest
																				   error:NULL] lastObject];
							}
							if (object)
								[destinationObject setValue:object forKey:key];
						}
						if ([key isEqualToString:@"hours"]) {
							NSMutableSet *set = [destinationObject mutableSetValueForKey:key];
							[set removeAllObjects];
							for (NSDictionary *sourceHours in value) {
								NSManagedObject *destinationHours = [NSEntityDescription insertNewObjectForEntityForName:@"AFEventHours" inManagedObjectContext:self.managedObjectContext];
								[destinationHours setValue:[sourceObject valueForKey:@"active"] forKey:@"active"];
								for (NSString *hoursKey in sourceHours) {
									if ([hoursKey isEqualToString:@"notes"]) {
										if (![sourceHours[hoursKey] isKindOfClass:[NSNull class]])
											[destinationHours setValue:sourceHours[hoursKey] forKey:hoursKey];
									} else {
										if (![sourceHours[hoursKey] isKindOfClass:[NSNull class]]) {
											NSDate *date = [NSDate dateWithTimeIntervalSince1970:[sourceHours[hoursKey] doubleValue]];
											[destinationHours setValue:date forKey:hoursKey];
											if ([hoursKey isEqualToString:@"opens"]) {
												[destinationHours setValue:[dateSortFormatter stringFromDate:date] forKey:@"daySort"];
												[destinationHours setValue:[dateFormatter stringFromDate:date] forKey:@"day"];
											}
										}
									}
								}
								[set addObject:destinationHours];
							}
						}
					} else if ([property isKindOfClass:[NSPropertyDescription class]]) {
						if (![value isKindOfClass:[NSNull class]]) {
							if ([[property attributeValueClassName] isEqualToString:@"NSDate"])
								[destinationObject setValue:[NSDate dateWithTimeIntervalSince1970:[value doubleValue]] forKey:key];
							else
								[destinationObject setValue:value forKey:key];
						}
					}
				}
				if ([entityName isEqualToString:@"AFArtist"]) {
					[destinationObject setValue:[[[destinationObject valueForKey:@"name"] substringToIndex:1] uppercaseString] forKey:@"initial"];
					artists[sourceObject[@"id"]] = destinationObject;
				}
				if ([entityName isEqualToString:@"AFCategory"]) {
					NSString *group = [destinationObject valueForKey:@"group"];
					NSString *groupSort;
					if([group hasPrefix:@"Event"])
						groupSort = [@"1" stringByAppendingString:group];
					else if([group hasPrefix:@"Visual"])
						groupSort = [@"2" stringByAppendingString:group];
					else if([group hasPrefix:@"Design"])
						groupSort = [@"3" stringByAppendingString:group];
					else if([group hasPrefix:@"Performing"])
						groupSort = [@"4" stringByAppendingString:group];
					else if([group hasPrefix:@"Other"])
						groupSort = [@"5" stringByAppendingString:group];
					else
						groupSort = [@"0" stringByAppendingString:group];
						
					[destinationObject setValue:groupSort forKey:@"groupSort"];
					categories[sourceObject[@"id"]] = destinationObject;
				}
				if ([entityName isEqualToString:@"AFVenue"])
					venues[sourceObject[@"id"]] = destinationObject;
			});
			processed++;
			float progress = (float)processed / (float) numResults;
			progress *= 0.2;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"AFProgressUpdate"
																object:self
															  userInfo:@{@"percent" : [NSNumber numberWithFloat:progress + overallProgress]}];
		}
		[self saveContext];
		if (latestObjectTimestamp > 0) {
			[[NSUserDefaults standardUserDefaults] setDouble:latestObjectTimestamp forKey:lastUpdatedKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		currentFeed++;
		overallProgress += 0.2;
		if (currentFeed < 5) {
			[self loadNextFeed];
		} else {
			artists = nil;
			categories = nil;
			venues = nil;
			dateFormatter = nil;
			dateSortFormatter = nil;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"AFProgressComplete"
																object:self
															  userInfo:nil];
		}
	} else {
		dispatch_sync(dispatch_get_main_queue(), ^{
			[[[UIAlertView alloc] initWithTitle:@"Error"
										message:@"Unable to load schedule, please try again."
									   delegate:self
							  cancelButtonTitle:nil
							  otherButtonTitles:@"Try Again", nil] show];
		});
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		[self loadNextFeed];
	});
}

- (void)loadData {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		[self loadNextFeed];
	});
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		[_managedObjectContext setPersistentStoreCoordinator:coordinator];
	}
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ArtsFest" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ArtsFest.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    if (![storeURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error])
        NSLog(@"Failed to set iCloud backup attribute: %@", [error localizedDescription]);
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    NSURL *appSupportUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[appSupportUrl path]])
        if (![[NSFileManager defaultManager] createDirectoryAtURL:appSupportUrl withIntermediateDirectories:YES attributes:nil error:NULL])
            NSLog(@"Failed to create application support directory.");
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
