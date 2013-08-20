//
//  AFSplashViewController.m
//  ArtsFest
//
//  Created by Jose Castillo on 2/10/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFSplashViewController.h"

@interface AFSplashViewController ()

@end

@implementation AFSplashViewController

- (void)updateProgress:(NSNotification *)notification {
	NSDictionary *userInfo = [notification userInfo];
	dispatch_sync(dispatch_get_main_queue(), ^{
		self.progressView.progress = [userInfo[@"percent"] floatValue];
	});
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateProgress:)
												 name:@"AFProgressUpdate"
											   object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
