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
    
    // Initialize note view and customize note button
    [self initializeNotesView];
    self.noteButton.layer.cornerRadius = self.noteButton.layer.frame.size.width/2.0;
    self.noteButton.layer.borderWidth = 2.0;
    self.noteButton.layer.borderColor = themeNavBar4.CGColor;
    [self.noteButton setTitleColor:themeNavBar4 forState:UIControlStateNormal];
    
    // Tap gesture: hide note view when taping on view
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNoteView:)];
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
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
    self.categoryImage.image = [self checkExerciseCategory:[self.exerciseSetting.baseExercise.category integerValue]];
    
    if (![self.exerciseSetting.note isEqualToString:@""]) {
        self.noteButton.enabled = YES;
        self.noteButton.alpha = 1.0;
    } else {
        self.noteButton.enabled = NO;
        self.noteButton.alpha = 0.2;
    }
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

// Return category image for exercise name depending on the category
- (UIImage *)checkExerciseCategory:(NSInteger)tag
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    switch (tag) {
        case 1:
            return [UIImage imageNamed:@"category_blue.png"];
        case 2:
            return [UIImage imageNamed:@"category_red.png"];
        case 3:
            return [UIImage imageNamed:@"category_yellow.png"];
        case 4:
            return [UIImage imageNamed:@"category_green.png"];
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

- (void)initializeNotesView {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    self.noteView = [[UITextView alloc] initWithFrame:CGRectMake(20, 312, 280, 115)];
    self.noteView.layer.borderColor = themeNavBar4.CGColor;
    self.noteView.layer.borderWidth = 1.0;
    self.noteView.layer.cornerRadius = 8.0;
    self.noteView.font = [UIFont systemFontOfSize:16.0];
    self.noteView.textColor = grey;
    self.noteView.editable = NO;
    self.noteView.hidden = YES;
    
    [self.view addSubview:self.noteView];
}

/* Show the notes */
- (IBAction)showNotes:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if (![self.exerciseSetting.note isEqualToString:@""]) {
        self.noteView.text = self.exerciseSetting.note;
        self.noteView.hidden = NO;
    }
}

- (IBAction)hideNoteView:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    self.noteView.hidden = YES;
}

/* Start timer if there is a time set for the exercise */
- (IBAction)startTimer:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Hide the note view
    [self hideNoteView:self];
    
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

    // Hide the note view
    [self hideNoteView:self];
    
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

    // Hide the note view
    [self hideNoteView:self];
    
    if (exerciseIndex != 0) {
        exerciseIndex--;
        [self startNextExercise];
    }
}

/* Go to next exercise */
- (IBAction)nextExercise:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Hide the note view
    [self hideNoteView:self];
    
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
