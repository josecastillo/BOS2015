//
//  AFFavoriteEventsListViewController.h
//  ArtsFest
//
//  Created by Joey Castillo on 5/14/15.
//  Copyright (c) 2015 Panchromatic, LLC. All rights reserved.
//

#import "AFListingViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AFFavoriteEventsListViewController : AFListingViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSDateFormatter *timeFormatter;
    dispatch_once_t onceToken;
}

@end
