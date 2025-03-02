//
//  RunWorkoutViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-26.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "ExerciseSetting.h"

@interface RunWorkoutViewController : UIViewController <UIGestureRecognizerDelegate>

// Timer
@property (nonatomic, strong) NSTimer *secondsTimer;

@property (nonatomic, strong) Workout *workout;
@property (nonatomic, strong) ExerciseSetting *exerciseSetting;
@property (nonatomic) NSMutableArray *exercisesForWorkout;

@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *noteButton;
@property (strong) UITextView *noteView;
@property (weak, nonatomic) IBOutlet UILabel *minDisplay;
@property (weak, nonatomic) IBOutlet UILabel *secDisplay;
@property (weak, nonatomic) IBOutlet UILabel *colonLabel;
@property (weak, nonatomic) IBOutlet UIButton *startLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsTotal;
@property (weak, nonatomic) IBOutlet UILabel *setsTotal;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@property (weak, nonatomic) IBOutlet UIButton *previousArrowButton;
@property (weak, nonatomic) IBOutlet UIButton *previousExerciseName;
@property (weak, nonatomic) IBOutlet UIButton *nextArrowButton;
@property (weak, nonatomic) IBOutlet UIButton *nextExerciseName;

- (IBAction)showNotes:(id)sender;
- (IBAction)startTimer:(id)sender;
- (IBAction)resetTimer:(id)sender;
- (IBAction)previousExercise:(id)sender;
- (IBAction)nextExercise:(id)sender;
- (IBAction)stopWorkout:(id)sender;

@end
