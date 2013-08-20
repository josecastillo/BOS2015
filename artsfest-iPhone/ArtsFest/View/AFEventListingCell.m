//
//  AFEventListingCell.m
//  ArtsFest
//
//  Created by Jose Castillo on 5/14/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFEventListingCell.h"

@implementation AFEventListingCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.nameLabel.text = nil;
    self.locationlabel.text = nil;
    self.hoursLabel.text = nil;
    self.distanceLabel.text = nil;
}

@end
