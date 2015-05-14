//
//  AFSponsorsViewController.m
//  ArtsFest
//
//  Created by Jose Castillo on 2/10/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import "AFSponsorListViewController.h"
#import <objc/runtime.h>

@interface AFSponsorListViewController ()

@property (nonatomic, strong) NSCharacterSet *charactersToTrim;

@end

@implementation AFSponsorListViewController

static void *urlToken;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.entityName = @"AFSponsor";
	self.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"sponsor_level" ascending:YES], [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [object valueForKey:@"name"];
    cell.detailTextLabel.text = [object valueForKey:@"short_desc"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[super tableView:tableView didSelectRowAtIndexPath:indexPath];
	NSManagedObject *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSString *website = [event valueForKey:@"website"];
	if ([website isKindOfClass:[NSString class]] && [website length]) {
		NSURL *url = [NSURL URLWithString:website];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"External Link"
														message:@"This web site will open in Safari."
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"Open Safari", nil];
		objc_setAssociatedObject(alert, &urlToken, url, OBJC_ASSOCIATION_RETAIN);
		[alert show];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex) {
		NSURL *url = objc_getAssociatedObject(alertView, &urlToken);
		[[UIApplication sharedApplication] openURL:url];
	}
}

@end
