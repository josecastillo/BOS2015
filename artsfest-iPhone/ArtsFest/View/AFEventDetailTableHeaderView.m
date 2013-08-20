//
//  AFEventDetailTableHeaderView.m
//  ArtsFest
//
//  Created by Jose Castillo on 5/15/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFEventDetailTableHeaderView.h"

@implementation AFEventDetailTableHeaderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
		self.backgroundView = nil;
    }
    return self;
}

@end
