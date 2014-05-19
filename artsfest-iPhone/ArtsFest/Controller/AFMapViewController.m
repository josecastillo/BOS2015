//
//  AFMapViewController.m
//  ArtsFest
//
//  Created by Jose Castillo on 5/20/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFMapViewController.h"
#import "AFDataSource.h"
#import "AFVenueAnnotation.h"
#import "AFVenueAnnotationView.h"
#import "AFVenueDetailViewController.h"

@interface AFMapViewController ()

@end

@implementation AFMapViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
    self.managedObjectContext.parentContext = [[AFDataSource defaultSource] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AFVenue" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Set the sort descriptors.
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"map_identifier" ascending:YES]]];
	
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        for(NSManagedObject *venue in results) {
            AFVenueAnnotation *annotation = [[AFVenueAnnotation alloc] initWithVenue:venue];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.mapView addAnnotation:annotation];
            });
        }
        canUpdateMarkers = YES;
    });
	
	MKCoordinateRegion targetRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(40.697998, -73.923483), MKCoordinateSpanMake(0.047765, 0.054932));
	self.mapView.region = targetRegion;
    self.mapView.showsPointsOfInterest = NO;
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
																			 style:UIBarButtonItemStyleBordered
																			target:nil
																			action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	if(canUpdateMarkers) {
		canUpdateMarkers = NO;
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
			for(AFVenueAnnotation *annotation in self.mapView.annotations) {
				id annotationView = [self.mapView viewForAnnotation:annotation];
				dispatch_sync(dispatch_get_main_queue(), ^{
					if ([annotationView respondsToSelector:@selector(configureImage)])
						[annotationView configureImage];
				});
			}
		});
		canUpdateMarkers = YES;
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(AFVenueAnnotation *)annotation {
	if ([annotation isKindOfClass:[MKUserLocation class]])
		return nil;
    
	NSString *identifier = [@"Annotation" stringByAppendingString:[annotation.venue valueForKey:@"map_identifier"]];
	
	MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
	if (!annotationView) {
		annotationView = [[AFVenueAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
		annotationView.canShowCallout = YES;
		annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	} else {
		annotationView.annotation = annotation;
	}
	
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	[self performSegueWithIdentifier:@"MapToVenueDetailSegue" sender:view.annotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)scrollToCurrentLocation:(id)sender {
    if (self.mapView.userLocation.coordinate.latitude == 0 || self.mapView.userLocation.coordinate.longitude == 0)
        return;
    
    NSLog(@"%f, %f", self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude);
	MKCoordinateRegion targetRegion = MKCoordinateRegionMake(self.mapView.userLocation.coordinate, MKCoordinateSpanMake(0.0047765, 0.0054932));
	[self.mapView setRegion:targetRegion animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	AFVenueAnnotation *annotation = (AFVenueAnnotation *)sender;
	AFVenueDetailViewController *destinationViewController = (AFVenueDetailViewController *)segue.destinationViewController;
	destinationViewController.venue = annotation.venue;
}
@end
