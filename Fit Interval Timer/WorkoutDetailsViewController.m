//
//  WorkoutDetailsViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-02.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "WorkoutDetailsViewController.h"
#import "Workout.h"

@interface WorkoutDetailsViewController ()

@end

@implementation WorkoutDetailsViewController

UIToolbar *pickerToolbar;
Workout *workout;


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

    // Workout object initiailization
    workout = [[Workout alloc] init];
    
    // Time pick initialization
//    self.timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 500, self.timePicker.frame.size.width, self.timePicker.frame.size.height)];
    self.timePicker = [[UIPickerView alloc] init];
    self.timePicker.showsSelectionIndicator = YES;
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    self.durationTextField.inputView = self.timePicker;
    
    // Done bar button
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone)];
    
    pickerToolbar.items = [NSArray arrayWithObjects:space, done, nil];
    self.durationTextField.inputAccessoryView = pickerToolbar;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Touch row to add text
    if (indexPath.section == 0) {
        [self.nameTextField becomeFirstResponder];
    } else if (indexPath.section == 1) {
        [self.durationTextField becomeFirstResponder];
    }
}

/* UIPickerViewDataSource */

// Time picker Done button
-(void)pickerDone
{
    if (workout.secDuration == NULL) {
        workout.secDuration = @"00";
    }
    if (workout.minDuration == NULL) {
        workout.minDuration = @"00";
    }
    
    self.durationTextField.text = [NSString stringWithFormat:@"%@:%@", workout.minDuration, workout.secDuration];
    [self.durationTextField resignFirstResponder];
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
        workout.secDuration = [self.secArray objectAtIndex:row];
    } else {
        workout.minDuration = [self.minArray objectAtIndex:row];
    }
}

/* Bar buttons: cancel and done */

- (IBAction)cancel:(id)sender
{
    [self.delegate workoutDetailsViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    workout.workoutName = self.nameTextField.text;
    
    [self.delegate workoutDetailsViewController:self didAddWorkout:workout];

}

@end
