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

@interface AllWorkoutsTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic) NSMutableArray *workoutList;

@property (nonatomic, strong) WorkoutCell* activeCell;
@property (nonatomic, strong) NSIndexPath* indexPath;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) ADBannerView *bannerView;

- (IBAction)addWorkout:(id)sender;

@end
