//
//  AFVenueAnnotationView.m
//  ArtsFest
//
//  Created by Jose Castillo on 5/21/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFVenueAnnotationView.h"
#import "AFVenueAnnotation.h"

@implementation AFVenueAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
		self.calloutOffset = CGPointMake(0, -2);
    }
    return self;
}

- (void)configureImage {
	AFVenueAnnotation *annotation = (AFVenueAnnotation *)self.annotation;
	NSString *mapID = nil;
    if ([[annotation.venue valueForKey:@"map_identifier"] intValue])
        mapID = [NSString stringWithFormat:@"%03d", [[annotation.venue valueForKey:@"map_identifier"] intValue]];
    else if ([[annotation.venue valueForKey:@"map_identifier"] length] == 1)
        mapID = [annotation.venue valueForKey:@"map_identifier"];
    else
        mapID = @"";
	UIImage *baseImage;
	BOOL isHappening = NO;
	
	for (NSManagedObject *event in [annotation.venue valueForKey:@"events"]) {
		for (NSManagedObject *hour in [event valueForKey:@"hours"]) {
			NSDate *opens = [hour valueForKey:@"opens"];
			NSDate *closes = [hour valueForKey:@"closes"];
			NSDate *now = [NSDate date];
			if (closes)
				isHappening = ([now compare:opens] == NSOrderedDescending) && ([now compare:closes] == NSOrderedAscending);
			if (isHappening)
				break;
		}
		if (isHappening)
			break;
	}
    if (isHappening)
        baseImage = [UIImage imageNamed:@"map-circle.png"];
    else
        baseImage = [UIImage imageNamed:@"map-circle-inactive.png"];
	
	UIGraphicsBeginImageContextWithOptions(baseImage.size, NO, baseImage.scale);
	[baseImage drawAtPoint:CGPointZero];
	[[UIColor whiteColor] set];
	CGRect labelRect;
	if ([mapID length] < 3)
		labelRect = CGRectMake(0, 5, baseImage.size.width, baseImage.size.height - 6);
	else
		labelRect = CGRectMake(0, 5, baseImage.size.width - 1, baseImage.size.height - 6);
	[mapID drawInRect:labelRect
			 withFont:[UIFont fontWithName:@"EuphemiaUCAS" size:10.0f]
		lineBreakMode:NSLineBreakByClipping
			alignment:NSTextAlignmentCenter];
	self.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
	[super setAnnotation:annotation];
	[self configureImage];
}

@end
