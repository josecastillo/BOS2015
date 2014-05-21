//
//  AFEventsViewController.m
//  ArtsFest
//
//  Created by Jose Castillo on 2/10/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFEventListViewController.h"
#import "AFEventDetailViewController.h"
#import "AFEventListingCell.h"

@interface AFEventListViewController ()

@end

@implementation AFEventListViewController

- (void)awakeFromNib {
	[super awakeFromNib];
	self.entityName = @"AFEventHours";
	self.predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", @"event.section", @"events"];
	self.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"daySort" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"opens" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"event.name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
	self.sectionNameKeyPath = @"day";
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	
	timeFormatter = [[NSDateFormatter alloc] init];
	timeFormatter.timeZone = [[NSTimeZone alloc] initWithName:@"US/Eastern"];
	timeFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[timeFormatter setDateFormat:@"h:mma"];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[locationManager startUpdatingLocation];
	dispatch_once(&onceToken, ^{
		[self scrollToNow];
	});
}

- (void)viewWillDisappear:(BOOL)animated {
	[locationManager stopUpdatingLocation];
	[super viewWillDisappear:animated];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	[self.tableView reloadRowsAtIndexPaths:self.tableView.indexPathsForVisibleRows
						  withRowAnimation:UITableViewRowAnimationNone];
}

- (void)configureCell:(AFEventListingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *eventHours = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.nameLabel.text = [eventHours valueForKeyPath:@"event.name"];
    cell.locationlabel.text = [[eventHours valueForKeyPath:@"event.venue.address"] stringByAppendingFormat:@" %@", [eventHours valueForKeyPath:@"event.room"]];
	if ([eventHours valueForKey:@"closes"])
		cell.hoursLabel.text = [NSString stringWithFormat:@"%@ – %@", [timeFormatter stringFromDate:[eventHours valueForKey:@"opens"]],[timeFormatter stringFromDate:[eventHours valueForKey:@"closes"]]];
	else
		cell.hoursLabel.text = [NSString stringWithFormat:@"%@ –", [timeFormatter stringFromDate:[eventHours valueForKey:@"opens"]]];
	CLLocation *location = locationManager.location;
	if (location && [eventHours valueForKeyPath:@"event.venue"])
	{
		CLLocation *eventLocation = [[CLLocation alloc] initWithLatitude:[[eventHours valueForKeyPath:@"event.venue.lat"] doubleValue] longitude:[[eventHours valueForKeyPath:@"event.venue.lon"] doubleValue]];
		CLLocationDistance distance = [eventLocation distanceFromLocation:locationManager.location];
		if (distance < 1609)
			cell.distanceLabel.text = [NSString stringWithFormat:@"%.0f feet away", distance * 3.2808399];
		else if (distance > 1689)
			cell.distanceLabel.text = [NSString stringWithFormat:@"%.1f miles away", distance / 1609.344];
		else
			cell.distanceLabel.text = [NSString stringWithFormat:@"1 mile away"];
	} else {
		cell.distanceLabel.text = @"";
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
	AFEventDetailViewController *destinationViewController = (AFEventDetailViewController *)[segue destinationViewController];
	destinationViewController.event = [object valueForKey:@"event"];
}

- (IBAction)scrollToNow {
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"closes" ascending:YES];
	NSDate *now = [NSDate date];
	NSPredicate *timesPredicate = [NSPredicate predicateWithFormat:@"%K >= %@", @"closes", now];
	NSFetchRequest *getLatestEvents = [[NSFetchRequest alloc] initWithEntityName:@"AFEventHours"];
	getLatestEvents.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:self.predicate, timesPredicate, nil]];
	getLatestEvents.sortDescriptors = [NSArray arrayWithObject:descriptor];
	NSArray *results = [self.managedObjectContext executeFetchRequest:getLatestEvents
																error:NULL];
	
	if ([results count])
	{
		NSManagedObject *nextEventTime = [results objectAtIndex:0];
		NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:nextEventTime];
		if (indexPath)
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]
								  atScrollPosition:UITableViewScrollPositionTop
										  animated:YES];
	}
	else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

@end
