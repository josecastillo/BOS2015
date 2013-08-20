//
//  AFMapViewController.h
//  ArtsFest
//
//  Created by Jose Castillo on 5/20/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AFMapViewController : UIViewController <MKMapViewDelegate> {
	BOOL canUpdateMarkers;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSArray *locations;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)scrollToCurrentLocation:(id)sender;
@end
