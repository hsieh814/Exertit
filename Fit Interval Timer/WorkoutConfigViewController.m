//
//  WorkoutConfigViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2/16/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "WorkoutConfigViewController.h"
#import "Exercise.h"
#import "AllExercisesTableViewController.h"

@interface WorkoutConfigViewController ()

@end

@implementation WorkoutConfigViewController

UIToolbar *pickerToolbar;
NSTimeInterval nsTimeInterval;
NSString *seconds;
NSString *minutes;

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
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
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
    
    // NSTimeInterval set to 0
    nsTimeInterval = 0.0;
    
    // Initialize newExericse object
    self.exerciseSetting = [ExerciseSetting createEntity];
}

// called everytime we enter the view
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([segue.identifier isEqualToString:@"selectExercise"]) {
        AllExercisesTableViewController *allExercisesTableViewController = segue.destinationViewController;
        
//        allExercisesTableViewController.workout = self.workout;
        
        // Set the title of next controller
        allExercisesTableViewController.title = @"Select Exercise";
        // Hide the sidebar button
        allExercisesTableViewController.navigationItem.leftBarButtonItem = nil;
        
        // Set the delegate
        allExercisesTableViewController.delegate = self;
    }
}

/* UIPickerViewDataSource */

// Time picker Done button
-(void)pickerDone
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if (seconds == nil) {
        seconds = @"00";
    }
    if (minutes == nil) {
        minutes = @"00";
    }
    
    nsTimeInterval = [minutes doubleValue] * 60 + [seconds doubleValue];
    self.exerciseSetting.timeInterval = [NSNumber numberWithDouble:nsTimeInterval];
    self.durationText.text = [NSString stringWithFormat:@"%@:%@", minutes, seconds];
    
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
    if (component == 1) {
        return [self.secArray count];
    } else {
        return [self.minArray count];
    }
}

/* UIPickerViewDelegate */

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 1) {
        return [self.secArray objectAtIndex:row];
    } else {
        return [self.minArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 1) {
        seconds = [self.secArray objectAtIndex:row];
    } else {
        minutes = [self.minArray objectAtIndex:row];
    }
}

/* Bar buttons */

- (IBAction)cancel:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Delete the newly created exercise entity
    [self.exerciseSetting deleteEntity];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSLog(@"%@", self.workout);
    
    NSLog(@"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    NSLog(@"%@", self.exerciseSetting);
    
    [self.workout addExerciseGroupObject:self.exerciseSetting];
    [self saveContext];
    
    NSLog(@"#########################################################");
    NSLog(@"%@", self.workout);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* Save data */
- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

/* Steppers for reps and sets */

- (IBAction)repsStepper:(UIStepper *)sender {
    
    double value = [sender value];
    [self.repsText setText:[NSString stringWithFormat:@"%02d", (int)value] ];
    self.exerciseSetting.reps = [NSNumber numberWithDouble:value];
}

- (IBAction)setsStepper:(UIStepper *)sender {

    double value = [sender value];
    [self.setsText setText:[NSString stringWithFormat:@"%02d", (int)value] ];
    self.exerciseSetting.sets = [NSNumber numberWithDouble:value];
}

#pragma mark - AllExercisesTableViewControllerDelegate

// Pass the selected Exercise object
- (void)allExercisesViewControllerDidSelectWorkout:(AllExercisesTableViewController *)controller didSelectExercise:(Exercise *)exercise
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // display the selected exercise's name
    self.selectedExerciseLabel.text = exercise.exerciseName;
    self.exerciseSetting.name = exercise.exerciseName;
    self.exerciseSetting.baseExercise = exercise;
    NSLog(@"%@", self.exerciseSetting.baseExercise);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
