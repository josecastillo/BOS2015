//
//  AFEventsViewController.h
//  ArtsFest
//
//  Created by Jose Castillo on 2/10/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFListingViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AFEventListViewController : AFListingViewController <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	NSDateFormatter *timeFormatter;
	dispatch_once_t onceToken;
}
- (IBAction)scrollToNow;
@end
