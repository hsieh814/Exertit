//
//  RunWorkoutViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-26.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "RunWorkoutViewController.h"
#import "ExerciseSetting.h"
#import "Exercise.h"

@interface RunWorkoutViewController ()

@end

@implementation RunWorkoutViewController

int exerciseIndex, minutesCount, secondsCount, pauseTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Timer is invalid
    pauseTimer = 1;
    
    exerciseIndex = 0;
    
    // Start with index = 0
    [self startNextExercise];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Display the next ExerciseSetting info */
-(void)startNextExercise
{
    NSLog(@"[%@] %@: index = %d", NSStringFromClass([self class]), NSStringFromSelector(_cmd), exerciseIndex);

    self.exerciseSetting = [self.exercisesForWorkout objectAtIndex: exerciseIndex];

    self.nameLabel.text = self.exerciseSetting.baseExercise.exerciseName;
    self.repsTotal.text = [NSString stringWithFormat:@"%@", self.exerciseSetting.reps];
    self.setsTotal.text = [NSString stringWithFormat:@"%@", self.exerciseSetting.sets];
    
    // Set the min and sec display
    [self setMinuteAndSecondsFromTimeInterval];
    
    // Next exercise label
    if ( (exerciseIndex + 1) < [self.exercisesForWorkout count]) {
        ExerciseSetting *nextExerciseSetting = [self.exercisesForWorkout objectAtIndex:(exerciseIndex + 1)];
        [self.nextExerciseName setTitle:[NSString stringWithFormat:@"%@ >", nextExerciseSetting.baseExercise.exerciseName] forState:UIControlStateNormal];
    } else {
        [self.nextExerciseName setTitle:@"Done Workout!" forState:UIControlStateNormal];
    }
}

// Convert the TimeInterval to ints for minutes and seconds and display
-(void)setMinuteAndSecondsFromTimeInterval
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    int totalTimeInSeconds = [self.exerciseSetting.timeInterval intValue];
    minutesCount = totalTimeInSeconds / 60;
    secondsCount = (totalTimeInSeconds % 60);
    
    NSLog(@"totalTime = %d, minutes = %d, seconds = %d", totalTimeInSeconds, minutesCount, secondsCount);
    
    [self displayMinValue:minutesCount andSecValue:secondsCount];
}

/* Change the display values for the min and sec labels */
-(void)displayMinValue:(int)minutes andSecValue:(int)seconds {
    //    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    self.minDisplay.text = [NSString stringWithFormat:@"%02d", minutes];
    self.secDisplay.text = [NSString stringWithFormat:@"%02d", seconds];
}

/* Start timer if there is a time set for the exercise */
- (IBAction)startTimer:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (pauseTimer) {
        // Change label to PAUSE
        [self.startLabel setTitle:@"PAUSE" forState:UIControlStateNormal];
        
        self.secondsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                             target: self
                                                           selector:@selector(timer)
                                                           userInfo:nil
                                                            repeats:YES];
        
        pauseTimer = 0;
    } else {
        // Change label to RESUME
        [self.startLabel setTitle:@"RESUME" forState:UIControlStateNormal];
        
        [self.secondsTimer invalidate];
        self.secondsTimer = nil;
        pauseTimer = 1;
    }

}

/* Reset timer */
- (IBAction)resetTimer:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Stop the timer
    [self.secondsTimer invalidate];
    self.secondsTimer = nil;
    
    // Reset timer
    [self setMinuteAndSecondsFromTimeInterval];
    [self.startLabel setTitle:@"START" forState:UIControlStateNormal];
    pauseTimer = 1;
}

// Called every second when timePicker is active
- (void)timer {

    // Timer
    if (secondsCount == 0 && minutesCount == 0) {
        [self.secondsTimer invalidate];
        self.secondsTimer = nil;
        
        // Reset timer
        [self setMinuteAndSecondsFromTimeInterval];
        [self.startLabel setTitle:@"START" forState:UIControlStateNormal];
        pauseTimer = 1;
        
    } else if (secondsCount == 0) {
        minutesCount--;
        secondsCount = 59;
    } else {
        secondsCount--;
    }
    
    [self displayMinValue:minutesCount andSecValue:secondsCount];
}

/* Go to next exercise */
- (IBAction)nextExercise:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Make we did not reach the end of the workout (ie. there are still exercises left)
    if ( (exerciseIndex + 1) < [self.exercisesForWorkout count]) {
        exerciseIndex++;
        [self startNextExercise];
    }
    
}

/* Navigation bar 'x' - stop the workout */
- (IBAction)stopWorkout:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end