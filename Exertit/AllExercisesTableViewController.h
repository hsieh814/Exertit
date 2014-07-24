//
//  AllExercisesTableViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/5/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "NewExerciseTableViewController.h"
#import "Workout.h"
#import "ExerciseCell.h"

@class AllExercisesTableViewController;

@protocol AllExercisesTableViewControllerDelegate <NSObject>
- (void)allExercisesViewControllerDidSelectWorkout:(AllExercisesTableViewController *)controller didSelectExercise:(Exercise *)exercise;
@end

@interface AllExercisesTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate>

@property (nonatomic, weak) id <AllExercisesTableViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic) NSMutableArray *exerciseList;

@property (nonatomic, strong) ExerciseCell* activeCell;
@property (nonatomic, strong) NSIndexPath* indexPath;

// Select Exercise
@property (nonatomic, strong) Workout *workout;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) ADBannerView *bannerView;

@end
