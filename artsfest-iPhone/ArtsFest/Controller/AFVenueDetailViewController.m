//
//  AFVenueDetailViewController.m
//  ArtsFest
//
//  Created by Jose Castillo on 5/21/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFVenueDetailViewController.h"
#import "AFEventDetailViewController.h"
#import "AFVenueAnnotationView.h"
#import "AFVenueAnnotation.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface AFVenueDetailViewController ()

@end

@implementation AFVenueDetailViewController

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

    if ([self.mapView respondsToSelector:@selector(showsPointsOfInterest)])
        self.mapView.showsPointsOfInterest = NO;
}

- (void)viewWillAppear:(BOOL)animated {
	events = [[self.venue valueForKey:@"events"] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
	
	CGRect frame = self.tableView.tableHeaderView.frame;
	if ([self.venue valueForKey:@"name"]) {
		self.spaceNameLabel.text = [self.venue valueForKey:@"name"];
		frame.size.height = 240;
		self.tableView.tableHeaderView.frame = frame;
	} else {
		self.spaceNameLabel.text = @"";
		frame.size.height = 220;
		self.tableView.tableHeaderView.frame = frame;
	}
	self.addressLabel.text = [self.venue valueForKey:@"address"];
	
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[self.venue valueForKey:@"lat"] doubleValue], [[self.venue valueForKey:@"lon"] doubleValue]);
	MKCoordinateRegion targetRegion = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.005, 0.005));
	self.mapView.region = targetRegion;
	[self.mapView removeAnnotations:self.mapView.annotations];
	[self.mapView addAnnotation:[[AFVenueAnnotation alloc] initWithVenue:self.venue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(AFVenueAnnotation *)annotation
{
	if ([annotation isKindOfClass:[MKUserLocation class]])
		return nil;
	static NSString *Identifier = @"Annotation";
	
	MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:Identifier];
	if (!annotationView)
		annotationView = [[AFVenueAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:Identifier];
	else
		annotationView.annotation = annotation;
	
	return annotationView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSManagedObject *event = [events objectAtIndex:indexPath.row];
	if ([[event valueForKey:@"room"] length])
		cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", [event valueForKey:@"room"], [event valueForKey:@"name"]];
	else
		cell.textLabel.text = [event valueForKey:@"name"];
	NSArray *hours = [[event valueForKey:@"hours"] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"opens" ascending:YES]]];
	NSMutableArray *hourLines = [NSMutableArray arrayWithCapacity:4];
	for (NSManagedObject *hour in hours)
		if ([hour valueForKey:@"closes"])
			[hourLines addObject:[NSString stringWithFormat:@"%@, %@ – %@", [dateFormatter stringFromDate:[hour valueForKey:@"opens"]], [timeFormatter stringFromDate:[hour valueForKey:@"opens"]], [timeFormatter stringFromDate:[hour valueForKey:@"closes"]]]];
		else
			[hourLines addObject:[NSString stringWithFormat:@"%@, %@ – ", [dateFormatter stringFromDate:[hour valueForKey:@"opens"]], [timeFormatter stringFromDate:[hour valueForKey:@"opens"]]]];
	cell.detailTextLabel.text = [hourLines componentsJoinedByString:@"\r"];
	
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
	view.opaque = NO;
	view.backgroundColor = [UIColor clearColor];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 1;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	AFEventDetailViewController *destinationViewController = (AFEventDetailViewController *)segue.destinationViewController;
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
	destinationViewController.event = [events objectAtIndex:indexPath.row];
}

- (IBAction)showDirections:(id)sender {
    NSDictionary *address =
	@{
   (NSString *)kABPersonAddressStreetKey : [self.venue valueForKey:@"address"],
   (NSString *)kABPersonAddressCityKey : [self.venue valueForKey:@"city"],
   (NSString *)kABPersonAddressStateKey : [self.venue valueForKey:@"state"],
   (NSString *)kABPersonAddressCountryKey : [self.venue valueForKey:@"country"]
   };
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[self.venue valueForKey:@"lat"] doubleValue], [[self.venue valueForKey:@"lon"] doubleValue]);
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:address];
    MKMapItem *destinationMapItem = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
	
	[destinationMapItem openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
}

@end
