//
//  AllExercisesTableViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/5/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewExerciseViewController.h"
#import "timerAppDelegate.h"
#import "Workout.h"

@class AllExercisesTableViewController;

@protocol AllExercisesTableViewControllerDelegate <NSObject>
- (void)allExercisesViewControllerDidSelectWorkout:(AllExercisesTableViewController *)controller didSelectExercise:(Exercise *)exercise;
@end

@interface AllExercisesTableViewController : UITableViewController <NewExerciseViewControllerDelegate>

@property (nonatomic, weak) id <AllExercisesTableViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic) NSMutableArray *exerciseList;

// Select Exercise
@property (nonatomic, strong) Workout *workout;

@end
