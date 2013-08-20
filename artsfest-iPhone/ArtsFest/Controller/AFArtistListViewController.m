//
//  AFArtistsViewController.m
//  ArtsFest
//
//  Created by Jose Castillo on 2/10/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFArtistListViewController.h"

@interface AFArtistListViewController ()

@end

@implementation AFArtistListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.entityName = @"AFArtist";
	self.sectionNameKeyPath = @"initial";
	self.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"initial" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return [self.fetchedResultsController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [object valueForKey:@"name"];
}


@end
