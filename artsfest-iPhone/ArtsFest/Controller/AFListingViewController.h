//
//  AFListingViewController.h
//  ArtsFest
//
//  Created by Jose Castillo on 2/10/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFListingViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *entityName;
@property (strong, nonatomic) NSArray *sortDescriptors;
@property (strong, nonatomic) NSPredicate *predicate;
@property (strong, nonatomic) NSString *sectionNameKeyPath;
@end
