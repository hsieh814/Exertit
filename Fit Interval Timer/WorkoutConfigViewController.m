//
//  WorkoutConfigViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2/16/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "WorkoutConfigViewController.h"
#import "Exercise.h"
#import "timerAppDelegate.h"

@interface WorkoutConfigViewController ()

@end

timerAppDelegate *appDelegate;

@implementation WorkoutConfigViewController

UIToolbar *pickerToolbar;
Exercise *exercise;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", NSStringFromSelector(_cmd));

    // Managed Object Context
    appDelegate = [UIApplication sharedApplication].delegate;
//    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Initialize time array with times value to pick from
    self.minArray = [[NSMutableArray alloc] init];
    self.secArray = [[NSMutableArray alloc] init];
    
    NSArray *minSingleDigits = [[NSArray alloc] initWithObjects:@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07"
                                , @"08", @"09", nil];
    NSArray *secSingleDigits = [[NSArray alloc] initWithObjects:@"00", @"05", nil];
    
    [self.minArray addObjectsFromArray:minSingleDigits];
    [self.secArray addObjectsFromArray:secSingleDigits];
    
    for (int j = 10; j < 60; j++) {
        [self.minArray addObject:[NSString stringWithFormat:@"%d", j]];
    }
    
    for (int i = 2; i < 12; i++) {
        [self.secArray addObject:[NSString stringWithFormat:@"%d", i*5]];
    }

    // Exercise object initiailization
    exercise = [NSEntityDescription insertNewObjectForEntityForName:@"Exercise" inManagedObjectContext:self.managedObjectContext];
    
    // Time pick initialization
    //    self.timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 500, self.timePicker.frame.size.width, self.timePicker.frame.size.height)];
    self.timePicker = [[UIPickerView alloc] init];
    self.timePicker.showsSelectionIndicator = YES;
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    self.durationText.inputView = self.timePicker;
    
    // Done bar button
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone)];
    
    pickerToolbar.items = [NSArray arrayWithObjects:space, done, nil];
    self.durationText.inputAccessoryView = pickerToolbar;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* UIPickerViewDataSource */

// Time picker Done button
-(void)pickerDone
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (exercise.exerciseSecDuration == NULL) {
        exercise.exerciseSecDuration = @"00";
    }
    if (exercise.exerciseMinDuration == NULL) {
        exercise.exerciseMinDuration = @"00";
    }
    
    self.durationText.text = [NSString stringWithFormat:@"%@:%@", exercise.exerciseMinDuration, exercise.exerciseSecDuration];
    [self.durationText resignFirstResponder];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    // 2 columns: min and sec
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (component == 1) {
        return [self.secArray count];
    } else {
        return [self.minArray count];
    }
}

/* UIPickerViewDelegate */

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (component == 1) {
        return [self.secArray objectAtIndex:row];
    } else {
        return [self.minArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (component == 1) {
        exercise.exerciseSecDuration = [self.secArray objectAtIndex:row];
    } else {
        exercise.exerciseMinDuration = [self.minArray objectAtIndex:row];
    }
}

/* Bar buttons */

- (IBAction)cancel:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    NSLog(@"Cancel");
    [self.delegate workoutConfigViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    NSLog(@"Done");
    [self.delegate workoutConfigViewController:self didAddExercise:exercise];
}

/* Steppers for reps and sets */

- (IBAction)repsStepper:(UIStepper *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    double value = [sender value];
    [self.repsText setText:[NSString stringWithFormat:@"%02d", (int)value] ];
}

- (IBAction)setsStepper:(UIStepper *)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    double value = [sender value];
    [self.setsText setText:[NSString stringWithFormat:@"%02d", (int)value] ];
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([segue.identifier isEqualToString:@"AddExercise"]) {
        

    }
}


/* AddExerciseViewController delegate */

- (void)addExerciseViewControllerDidCancel:(AddExerciseViewController *)controller
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

}

- (void)addExerciseViewController:(AddExerciseViewController *)controller didAddExercise:(Exercise *)addExercise;
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    exercise = addExercise;
    if (exercise.exerciseReps != nil && exercise.exerciseSets != nil) {
        NSLog(@"set the reps and sets to default exercise values");
        [self.repsStepperItem setValue:[exercise.exerciseReps doubleValue]];
        [self.setsStepperItem setValue:[exercise.exerciseSets doubleValue]];
    } else if (exercise.exerciseSecDuration != nil && exercise.exerciseMinDuration != nil) {
        NSLog(@"set the min and sec to default exercise values");
        self.durationText.text = [NSString stringWithFormat:@"%@:%@", exercise.exerciseMinDuration, exercise.exerciseSecDuration];
    }
    
    self.selectedExercise.exerciseName.text = exercise.exerciseName;
}

@end
