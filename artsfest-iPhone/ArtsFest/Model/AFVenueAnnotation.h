//
//  AFVenueAnnotation.h
//  ArtsFest
//
//  Created by Jose Castillo on 5/20/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AFVenueAnnotation : NSObject <MKAnnotation>

- (id)initWithVenue:(NSManagedObject *)venue;

@property (nonatomic, strong) NSManagedObject *venue;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@end
