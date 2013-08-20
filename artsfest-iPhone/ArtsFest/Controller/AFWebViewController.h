//
//  AFWebViewController.h
//  ArtsFest
//
//  Created by Jose Castillo on 5/21/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFWebViewController : UIViewController
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@end
