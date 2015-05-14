//
//  AFEventDetailViewController.h
//  ArtsFest
//
//  Created by Jose Castillo on 5/12/13.
//  Copyright (c) 2013 Panchromatic, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFEventDetailViewController : UITableViewController <UIActionSheetDelegate> {
	NSDateFormatter *dateFormatter;
	NSDateFormatter *timeFormatter;
	NSMutableArray *eventCategories;
	NSMutableArray *eventFeatures;
	NSMutableArray *artistNames;
	BOOL showLongDescription;
}
@property (nonatomic, strong) NSManagedObject *event;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *timesLabel;
- (IBAction)toggleFavorite:(UIBarButtonItem *)sender;

@end
