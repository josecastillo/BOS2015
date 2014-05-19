//
//  AFAppearanceManager.m
//  ArtsFest
//
//  Created by Jose Castillo on 5/21/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFAppearanceManager.h"
#import <MapKit/MapKit.h>

@implementation AFAppearanceManager
+ (void)setupAppearance {
    if  (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        [[UIView appearance] setTintColor:[UIColor colorWithRed:254.0/255.0
                                                            green:0.0
                                                             blue:132.0/255.0
                                                            alpha:1.0]];
        [[MKAnnotationView appearance] setTintColor:[UIColor colorWithRed:0.0
                                                                  green:122.0/255.0
                                                                   blue:255.0/255.0
                                                                  alpha:1.0]];
    } else {
        [[UIProgressView appearance] setTrackImage:[[UIImage imageNamed:@"clear.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)]];
        [[UIProgressView appearance] setProgressImage:[[UIImage imageNamed:@"white.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)]];
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"magenta.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)] forBarMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"clear.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 4, 10, 4)]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 18, 1, 1)]
                                                          forState:UIControlStateNormal
                                                        barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 18, 1, 1)]
                                                          forState:UIControlStateHighlighted
                                                        barMetrics:UIBarMetricsDefault];
        [[UITabBar appearance] setBackgroundImage:[[UIImage imageNamed:@"black.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)]];
        [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage imageNamed:@"magenta.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)]];
    }
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -17)];
}
@end
