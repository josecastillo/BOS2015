//
//  AFVenueDetailViewController.h
//  ArtsFest
//
//  Created by Jose Castillo on 5/21/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AFVenueDetailViewController : UITableViewController <MKMapViewDelegate> {
	NSDateFormatter *dateFormatter;
	NSDateFormatter *timeFormatter;
	NSArray *events;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *spaceNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) NSManagedObject *venue;

- (IBAction)showDirections:(id)sender;

@end
