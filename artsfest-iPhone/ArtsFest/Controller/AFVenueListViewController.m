//
//  AFVenuesViewController.m
//  ArtsFest
//
//  Created by Jose Castillo on 2/10/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFVenueListViewController.h"

@interface AFVenueListViewController ()

@end

@implementation AFVenueListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.entityName = @"AFVenue";
	self.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [object valueForKey:@"name"];
    cell.detailTextLabel.text = [object valueForKey:@"address"];
}


@end
