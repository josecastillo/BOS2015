//
//  AFAppDelegate.m
//  ArtsFest
//
//  Created by Jose Castillo on 2/10/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFAppDelegate.h"
#import "AFDataSource.h"
#import "AFAppearanceManager.h"

@implementation AFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[AFAppearanceManager setupAppearance];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)dismissSplash:(NSNotification *)notification {
	dispatch_sync(dispatch_get_main_queue(), ^{
		[self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
	});
}

- (void)loadDataAndDismissSplash {
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(dismissSplash:)
												 name:@"AFProgressComplete"
											   object:nil];
	[self.window.rootViewController performSegueWithIdentifier:@"ShowSplash" sender:nil];
	[[AFDataSource defaultSource] loadData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self loadDataAndDismissSplash];
	});
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Saves changes in the application's managed object context before the application terminates.
	[[AFDataSource defaultSource] saveContext];
}
@end
