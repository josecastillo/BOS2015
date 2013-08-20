//
//  AFVenueAnnotation.m
//  ArtsFest
//
//  Created by Jose Castillo on 5/20/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFVenueAnnotation.h"

@implementation AFVenueAnnotation

- (id)initWithVenue:(NSManagedObject *)venue {
	self = [super init];
	if (self) {
		self.venue = venue;
		_coordinate = CLLocationCoordinate2DMake([[self.venue valueForKey:@"lat"] doubleValue], [[self.venue valueForKey:@"lon"] doubleValue]);
	}
	return self;
}

- (NSString *)title {
	NSSet *events = [self.venue valueForKey:@"events"];
	if ([events count] == 1) {
		return [[events anyObject] valueForKey:@"name"];
	} else {
		return [NSString stringWithFormat:@"%d events", [events count]];
	}
}

- (NSString *)subtitle {
	return [self.venue valueForKey:@"address"];
}

@end
