//
//  RunWorkoutViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-26.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"

@interface RunWorkoutViewController : UIViewController

@property (nonatomic, strong) Workout *workout;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *minDisplay;
@property (weak, nonatomic) IBOutlet UILabel *secDisplay;
@property (weak, nonatomic) IBOutlet UILabel *nextExercise;

- (IBAction)startTimer:(id)sender;
- (IBAction)decrementReps:(id)sender;
- (IBAction)decrementSets:(id)sender;

- (IBAction)stopWorkout:(id)sender;

@end
