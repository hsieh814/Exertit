//
//  AllWorkoutsTableViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-02.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "WorkoutCell.h"

@interface AllWorkoutsTableViewController : UITableViewController <ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic) NSMutableArray *workoutList;

@property (nonatomic, strong) WorkoutCell* activeCell;
@property (nonatomic, strong) NSIndexPath* indexPath;

- (IBAction)addWorkout:(id)sender;

@end
