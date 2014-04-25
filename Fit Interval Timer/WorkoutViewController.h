//
//  WorkoutViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2/15/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutConfigViewController.h"

@interface WorkoutViewController : UITableViewController

// Array of ExerciseSetting objects
@property (nonatomic) NSMutableArray *exercisesForWorkout;

@property (nonatomic, strong) Workout *workout;
@property (nonatomic, strong) NSString *workoutName;

@end
