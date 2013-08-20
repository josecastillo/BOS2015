//
//  AFWebViewController.m
//  ArtsFest
//
//  Created by Jose Castillo on 5/21/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFWebViewController.h"

@interface AFWebViewController ()

@end

@implementation AFWebViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.webView loadRequest:self.request];
}
@end
