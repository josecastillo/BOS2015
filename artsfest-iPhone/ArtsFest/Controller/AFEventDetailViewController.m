//
//  AFEventDetailViewController.m
//  ArtsFest
//
//  Created by Jose Castillo on 5/12/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFEventDetailViewController.h"
#import "AFEventDetailTableHeaderView.h"
#import "AFVenueDetailViewController.h"
#import <AddressBook/AddressBook.h>
#import <MapKit/MapKit.h>

@interface AFEventDetailViewController ()
@property (nonatomic, assign) CGFloat labelWidth;
@end

@implementation AFEventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:@"US/Eastern"];
	dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[dateFormatter setDateFormat:@"EEEE"];
	
	timeFormatter = [[NSDateFormatter alloc] init];
	timeFormatter.timeZone = [[NSTimeZone alloc] initWithName:@"US/Eastern"];
	timeFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[timeFormatter setDateFormat:@"h:mma"];
	
	artistNames = [[NSMutableArray alloc] initWithCapacity:10];
	eventCategories = [[NSMutableArray alloc] initWithCapacity:10];
	eventFeatures = [[NSMutableArray alloc] initWithCapacity:10];

	[self.tableView registerClass:[AFEventDetailTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"Header"];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
        self.labelWidth = 290;
    else
        self.labelWidth = 300;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
	if ([self.event valueForKey:@"venue"])
		self.navigationItem.rightBarButtonItem.title = @"Walk Here";
	else
		self.navigationItem.rightBarButtonItem.title = @"";
	
	[artistNames removeAllObjects];
	NSArray *artists = [[self.event valueForKey:@"artists"] allObjects];
	for (NSManagedObject *artist in artists)
		[artistNames addObject:[artist valueForKey:@"name"]];
	
	[eventCategories removeAllObjects];
	[eventFeatures removeAllObjects];
	NSArray *categories = [[self.event valueForKey:@"categories"] allObjects];
	for (NSManagedObject *category in categories) {
		if ([[category valueForKey:@"group"] isEqualToString:@"Event Features"] || [[category valueForKey:@"name"] rangeOfString:@"Hub"].location != NSNotFound)
			[eventFeatures addObject:[category valueForKey:@"name"]];
		else
			[eventCategories addObject:[category valueForKey:@"name"]];
	}
	
	self.titleLabel.text = [self.event valueForKey:@"name"];
	CGRect titleFrame = self.titleLabel.frame;
	titleFrame.size = [self.titleLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:17.0]
									   constrainedToSize:CGSizeMake(self.labelWidth, CGFLOAT_MAX)
										   lineBreakMode:NSLineBreakByWordWrapping];
	self.titleLabel.frame = titleFrame;
	self.tableView.tableHeaderView.frame = CGRectMake(0, 0, 320, 100.0 + titleFrame.size.height);
	
	NSArray *hours = [[self.event valueForKey:@"hours"] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"opens" ascending:YES]]];
	NSMutableArray *hourLines = [NSMutableArray arrayWithCapacity:4];
	for (NSManagedObject *hour in hours) {
		if ([hour valueForKey:@"closes"])
			[hourLines addObject:[NSString stringWithFormat:@"%@, %@ – %@", [dateFormatter stringFromDate:[hour valueForKey:@"opens"]], [timeFormatter stringFromDate:[hour valueForKey:@"opens"]], [timeFormatter stringFromDate:[hour valueForKey:@"closes"]]]];
		else
			[hourLines addObject:[NSString stringWithFormat:@"%@, %@ – ", [dateFormatter stringFromDate:[hour valueForKey:@"opens"]], [timeFormatter stringFromDate:[hour valueForKey:@"opens"]]]];
		if ([[hour valueForKey:@"notes"] isKindOfClass:[NSString class]])
			[hourLines addObject:[hour valueForKey:@"notes"]];
	}
	self.timesLabel.text = [hourLines componentsJoinedByString:@"\r"];
	
	self.tableView.tableHeaderView.backgroundColor = [UIColor colorWithRed:237.0 / 255.0
																	 green:237.0 / 255.0
																	  blue:237.0 / 255.0
																	 alpha:1.0];
	
	
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1; // description
			break;
		case 1:
			return 1; // just the address cell
			break;
		case 2:
			return 1;
			break;
		case 3:
			return 1;
			break;
		case 4:
			return 1;
			break;
		default:
			return 0;
			break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
	
	switch (indexPath.section) {
		case 0:
			cellIdentifier = @"EventSummaryCell";
			break;
		case 1:
			cellIdentifier = @"EventAddressCell";
			break;
		case 2:
			cellIdentifier = @"EventFeatureCell";
			break;
		case 3:
			cellIdentifier = @"EventMediumCell";
			break;
		case 4:
			cellIdentifier = @"EventArtistCell";
			break;
		default:
			cellIdentifier = @"Cell";
			break;
	}
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	switch (indexPath.section) {
		case 0:
			if (showLongDescription) {
				cell.textLabel.text = [NSString stringWithFormat:@"%@\r\r%@", [self.event valueForKey:@"short_desc"], [self.event valueForKey:@"long_desc"]];
				cell.detailTextLabel.text = @"\rLESS [-]";
			} else {
				cell.textLabel.text = [self.event valueForKey:@"short_desc"];
				if ([[self.event valueForKey:@"long_desc"] length])
					cell.detailTextLabel.text = @"\rMORE [+]";
				else
					cell.detailTextLabel.text = nil;
			}
			break;
		case 1: {
			NSString *firstLine = nil;
			NSString *secondLine = nil;
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			if ([[self.event valueForKeyPath:@"venue.name"] length])
				firstLine = [self.event valueForKeyPath:@"venue.name"];
			
			if (firstLine) {
				secondLine = [[self.event valueForKeyPath:@"venue.address"] stringByAppendingFormat:@" %@", [self.event valueForKey:@"room"]];
			} else {
				firstLine = [self.event valueForKeyPath:@"venue.address"];
				secondLine = [self.event valueForKey:@"room"];
			}
			
			if (!firstLine) {
				firstLine = @"All Over Bushwick";
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			
			cell.textLabel.text = firstLine;
			cell.detailTextLabel.text = secondLine;
		}
			break;
		case 2:
			cell.textLabel.text = [eventFeatures componentsJoinedByString:@", "];
			break;
		case 3:
			cell.textLabel.text = [eventCategories componentsJoinedByString:@", "];
			break;
		case 4:
			cell.textLabel.text = [artistNames componentsJoinedByString:@", "];
			break;
		default:
			break;
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			if (indexPath.row == 0) {
				CGSize summarySize;
				if (showLongDescription)
					summarySize = [[NSString stringWithFormat:@"%@\r\r%@", [self.event valueForKey:@"short_desc"], [self.event valueForKey:@"long_desc"]] sizeWithFont:[UIFont systemFontOfSize:13.0]
																									   constrainedToSize:CGSizeMake(self.labelWidth, CGFLOAT_MAX)
																										   lineBreakMode:NSLineBreakByWordWrapping];
				else
					summarySize = [[self.event valueForKey:@"short_desc"] sizeWithFont:[UIFont systemFontOfSize:13.0]
											  constrainedToSize:CGSizeMake(self.labelWidth, CGFLOAT_MAX)
												  lineBreakMode:NSLineBreakByWordWrapping];
				if ([[self.event valueForKey:@"long_desc"] length])
					return summarySize.height + 50;
				else
					return summarySize.height + 20;
			}
			else {
				return 36;
			}
		case 1:
			return 64;
		case 2:
			if ([eventFeatures count])
				return [[eventFeatures componentsJoinedByString:@", "] sizeWithFont:[UIFont systemFontOfSize:13.0]
																  constrainedToSize:CGSizeMake(self.labelWidth, CGFLOAT_MAX)
																	  lineBreakMode:NSLineBreakByWordWrapping].height + 10;
			else
				return 0;
			break;
		case 3:
			if ([eventCategories count])
				return [[eventCategories componentsJoinedByString:@", "] sizeWithFont:[UIFont systemFontOfSize:13.0]
																	constrainedToSize:CGSizeMake(self.labelWidth, CGFLOAT_MAX)
																		lineBreakMode:NSLineBreakByWordWrapping].height + 20;
			else
				return 0;
			break;
		case 4:
			if ([artistNames count])
				return [[artistNames componentsJoinedByString:@", "] sizeWithFont:[UIFont systemFontOfSize:13.0]
																constrainedToSize:CGSizeMake(self.labelWidth, CGFLOAT_MAX)
																	lineBreakMode:NSLineBreakByWordWrapping].height + 20;
			else
				return 0;
			break;
		default:
			return 44;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *title = [self tableView:tableView titleForHeaderInSection:section];
	if (!title)
		return nil;
	UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
	header.textLabel.text = title;
	return header;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 2)
		return @"FEATURES";
	else if (section == 3)
		return @"MEDIA";
	else if (section == 4)
		return @"ARTISTS";
	else
		return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 2)
		return [eventFeatures count] ? 30.0 : 0;
	else if (section == 3)
		return [eventCategories count] ? 30.0 : 0;
	else if (section == 4)
		return [artistNames count] ? 30.0 : 0;
	return 0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 1)
	{
		cell.backgroundColor = [UIColor colorWithRed:237.0 / 255.0
											   green:237.0 / 255.0
												blue:237.0 / 255.0
											   alpha:1.0];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section == 0 && [[self.event valueForKey:@"long_desc"] length]) {
		showLongDescription = !showLongDescription;
		[tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
				 withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	if ([self.event valueForKey:@"venue"])
		return YES;
	return NO;
}

- (IBAction)showDirections:(id)sender {
	if ([self.event valueForKey:@"venue"]) {
		NSDictionary *address =
		@{
		(NSString *)kABPersonAddressStreetKey : [self.event valueForKeyPath:@"venue.address"],
		(NSString *)kABPersonAddressCityKey : [self.event valueForKeyPath:@"venue.city"],
		(NSString *)kABPersonAddressStateKey : [self.event valueForKeyPath:@"venue.state"],
		(NSString *)kABPersonAddressCountryKey : [self.event valueForKeyPath:@"venue.country"]
		};
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[self.event valueForKeyPath:@"venue.lat"] doubleValue], [[self.event valueForKeyPath:@"venue.lon"] doubleValue]);
		MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:address];
		MKMapItem *destinationMapItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
		
		[destinationMapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	AFVenueDetailViewController *destinationViewController = (AFVenueDetailViewController *)segue.destinationViewController;
	destinationViewController.venue = [self.event valueForKey:@"venue"];
}

@end
