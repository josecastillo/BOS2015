//
//  AFTableHeaderView.m
//  ArtsFest
//
//  Created by Jose Castillo on 5/11/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFTableHeaderView.h"

@implementation AFTableHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:251.0/255.0
														   green:221.0/255.0
															blue:236.0/255.0
														   alpha:1];
		self.backgroundView = nil;
    }
    return self;
}

@end
