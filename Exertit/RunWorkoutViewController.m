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
    
    // Color and text customization
    [self.startLabel setTitleColor:appleGreen forState:UIControlStateNormal];
    [self.resetLabel setTitleColor:appleRed forState:UIControlStateNormal];
    [self.previousExerciseName setTitleColor:themeNavBar4 forState:UIControlStateNormal];
    [self.nextExerciseName setTitleColor:themeNavBar4 forState:UIControlStateNormal];
    
    // Start and reset buttons
    self.startLabel.layer.cornerRadius = 20.0f;
    self.startLabel.layer.borderWidth = 2.0;
    self.startLabel.layer.borderColor = self.startLabel.titleLabel.textColor.CGColor;
    self.resetLabel.layer.cornerRadius = 20.0f;
    self.resetLabel.layer.borderWidth = 2.0;
    self.resetLabel.layer.borderColor = self.resetLabel.titleLabel.textColor.CGColor;
    
    // Previous/Next exercise buttons
    self.previousArrowButton.backgroundColor = previousColor;
    [self.previousArrowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.previousExerciseName setTitleColor:previousColor forState:UIControlStateNormal];
    UIView *previousBottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.previousExerciseName.frame.size.height - 4.0f,
                                                                    self.previousExerciseName.frame.size.width, 4)];
    previousBottomBorder.backgroundColor = previousColor;
    [self.previousExerciseName addSubview:previousBottomBorder];
    
    self.nextArrowButton.backgroundColor = nextColor;
    [self.nextArrowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextExerciseName setTitleColor:nextColor forState:UIControlStateNormal];
    UIView *nextBottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, self.previousExerciseName.frame.size.height - 4.0f,
                                                                    self.previousExerciseName.frame.size.width, 4)];
    nextBottomBorder.backgroundColor = nextColor;
    [self.nextExerciseName addSubview:nextBottomBorder];
    
         
    // Exercise name
    self.nameLabel.layer.borderWidth = 2.0;
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
    self.weightLabel.text = [NSString stringWithFormat:@"%@", self.exerciseSetting.weight];
    
    self.nameLabel.layer.borderColor = [self checkExerciseCategory:[self.exerciseSetting.baseExercise.category integerValue]].CGColor;
    
    // Set the min and sec display
    [self setMinuteAndSecondsFromTimeInterval];
    
    if ([self.exerciseSetting.timeInterval intValue] == 0) {
        [self enableTimer:NO];
    } else {
        [self enableTimer:YES];
    }
    
    // Set previous exercise label if not the first exercise
    if (exerciseIndex != 0) {
        [self enableArrowButton:self.previousArrowButton];
        ExerciseSetting *previousExerciseSetting = [self.exercisesForWorkout objectAtIndex:(exerciseIndex - 1)];
        [self.previousExerciseName setTitle:[NSString stringWithFormat:@"%@", previousExerciseSetting.baseExercise.exerciseName] forState:UIControlStateNormal];
    } else {
        [self.previousExerciseName setTitle:@"" forState:UIControlStateNormal];
        [self disableArrowButton:self.previousArrowButton];
    }
    
    // Set next exercise label if not the last exercise
    if ( (exerciseIndex + 1) < [self.exercisesForWorkout count]) {
        [self enableArrowButton:self.nextArrowButton];
        ExerciseSetting *nextExerciseSetting = [self.exercisesForWorkout objectAtIndex:(exerciseIndex + 1)];
        [self.nextExerciseName setTitle:[NSString stringWithFormat:@"%@", nextExerciseSetting.baseExercise.exerciseName] forState:UIControlStateNormal];
    } else {
        [self.nextExerciseName setTitle:@"Done Workout!" forState:UIControlStateNormal];
        [self disableArrowButton:self.nextArrowButton];
    }
}

// Disable and fade the arrow button
-(void)disableArrowButton:(UIButton *)button {
    button.enabled = NO;
    button.alpha = 0.3;
}

// Enable and high opacity for arrow button
-(void)enableArrowButton:(UIButton *)button {
    button.enabled = YES;
    button.alpha = 1.0;
}

// Return border color for exercise name depending on the category
- (UIColor *)checkExerciseCategory:(NSInteger)tag
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    switch (tag) {
        case 1:
            return appleBlue;
        case 2:
            return appleRed;
        case 3:
            return appleYellow;
        case 4:
            return appleGreen;
        default:
            break;
    }
    
    return nil;
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

// Enable or diable the timer
- (void)enableTimer:(bool)isEnable
{
    double transparency;
    if (isEnable) {
        transparency = 1.0;
    } else {
        transparency = 0.3;
    }
    
    [self.minDisplay setUserInteractionEnabled:isEnable];
    [self.minDisplay setAlpha:transparency];
    [self.colonLabel setUserInteractionEnabled:isEnable];
    [self.colonLabel setAlpha:transparency];
    [self.secDisplay setUserInteractionEnabled:isEnable];
    [self.secDisplay setAlpha:transparency];
    [self.startLabel setUserInteractionEnabled:isEnable];
    [self.startLabel setAlpha:transparency];
    [self.resetLabel setUserInteractionEnabled:isEnable];
    [self.resetLabel setAlpha:transparency];
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

/* Go to previous exercise */
- (IBAction)previousExercise:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if (exerciseIndex != 0) {
        exerciseIndex--;
        [self startNextExercise];
    }
}

/* Go to next exercise */
- (IBAction)nextExercise:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Make we did not reach the end of the workout (ie. there are still exercises left)
    if ( (exerciseIndex + 1) < [self.exercisesForWorkout count]) {
        exerciseIndex++;
        [self startNextExercise];
    } else {
        // Clicked the "Done Workout!" button, exit the view.
        [self stopWorkout:self];
    }
    
}

/* Navigation bar 'x' - stop the workout */
- (IBAction)stopWorkout:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
