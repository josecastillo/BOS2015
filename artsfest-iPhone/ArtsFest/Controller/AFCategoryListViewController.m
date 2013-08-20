//
//  AFCategoriesViewController.m
//  ArtsFest
//
//  Created by Jose Castillo on 2/10/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFCategoryListViewController.h"

@implementation AFCategoryListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.entityName = @"AFCategory";
	self.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"groupSort" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES]];
	self.sectionNameKeyPath = @"groupSort";
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[[self.fetchedResultsController sections][section] name] substringFromIndex:1];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [object valueForKey:@"name"];
	NSSet *allEvents = [object valueForKey:@"events"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [[allEvents filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"section", @"studios"]] count]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	AFListingViewController *destinationViewController = (AFListingViewController *)segue.destinationViewController;
	if ([sender isKindOfClass:[UITableViewCell class]]) {
		NSManagedObject *category = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
		destinationViewController.title = [[sender textLabel] text];
		destinationViewController.predicate = [NSPredicate predicateWithFormat:@"(ANY %K == %@) AND (%K == %@)", @"event.categories", category, @"event.section", @"studios"];
	} else {
		destinationViewController.predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", @"event.section", @"studios"];
	}
}
@end
