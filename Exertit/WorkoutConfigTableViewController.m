//
//  WorkoutConfigTableViewController.m
//  Exertit
//
//  Created by Lena Hsieh on 2014-06-29.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "WorkoutConfigTableViewController.h"
#import "DefaultCell.h"
#import "Exercise.h"

@interface WorkoutConfigTableViewController ()

@end

@implementation WorkoutConfigTableViewController

UIToolbar *pickerToolbar;
NSTimeInterval nsTimeInterval;
NSString *seconds;
NSString *minutes;
bool createdNewExerciseSetting;

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
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [super viewDidLoad];

    // TableView customization
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = mediumBlue;
    
    // Make tableview start lower
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
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
    
    // NSTimeInterval set to 0
    nsTimeInterval = 0.0;
    
    // Set the minutes and seconds to nil to avoid messing up next picker's values
    minutes = nil;
    seconds = nil;
    
    [self initialSetup];
    
    // Dismiss keyboard when outside is touched
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Create or editting exercise settings.
-(void)initialSetup
{
    if (!self.exerciseSetting) {
        // Initialize newExericse object
        self.exerciseSetting = [ExerciseSetting createEntity];
        createdNewExerciseSetting = YES;
    } else {
        // Editing the settings
        createdNewExerciseSetting = NO;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    DefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfigCell" forIndexPath:indexPath];
    
    // Change spacing between cell
    [cell setDefaultHeightBorder:6];
    [cell setDefaultWidthBorder:10];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 260, 40)];
    [title setFont:[UIFont boldSystemFontOfSize:18.0]];
    title.textColor = themeNavBar4;
    
    switch (indexPath.row) {
        case 0:
        {
            self.selectedExerciseLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 220, 40)];
            self.selectedExerciseLabel.textColor = themeNavBar4;
            self.selectedExerciseLabel.font = [UIFont systemFontOfSize:22.0];
            
            if (createdNewExerciseSetting) {
                self.selectedExerciseLabel.text = @"Select Exercise";
            } else {
                [self.selectedExerciseLabel setText:self.exerciseSetting.baseExercise.exerciseName];
            }
            
            UILabel *selectedExericseArrow = [[UILabel alloc] initWithFrame:CGRectMake(260, 15, 40, 40)];
            selectedExericseArrow.textColor = themeNavBar4;
            selectedExericseArrow.font = [UIFont boldSystemFontOfSize:24.0];
            selectedExericseArrow.text = @">";
            
            [cell addSubview:self.selectedExerciseLabel];
            [cell addSubview:selectedExericseArrow];
            
            break;
        }
        case 1:
        {
            title.text = @"Duration";
            
            self.durationText = [[UITextField alloc] initWithFrame:CGRectMake(150, 15, 100, 40)];
            self.durationText.layer.borderColor = themeNavBar4.CGColor;
            self.durationText.layer.borderWidth = 1.0;
            self.durationText.layer.cornerRadius = 8.0;
            self.durationText.textColor = themeNavBar4;
            self.durationText.font = [UIFont systemFontOfSize:20.0];
            self.durationText.textAlignment = NSTextAlignmentCenter;
            
            // Time pick initialization
            self.timePicker = [[UIPickerView alloc] init];
            self.timePicker.showsSelectionIndicator = YES;
            self.timePicker.delegate = self;
            self.timePicker.dataSource = self;
            self.timePicker.backgroundColor = [UIColor whiteColor];
            self.durationText.inputView = self.timePicker;
            
            // Done bar button
            pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
            pickerToolbar.barStyle = UIBarStyleDefault;
            UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone)];
            pickerToolbar.items = [NSArray arrayWithObjects:space, done, nil];
            self.durationText.inputAccessoryView = pickerToolbar;
            
            if (!createdNewExerciseSetting) {
                // Set the saved values for the time picker and time label
                int totalTimeInSeconds = [self.exerciseSetting.timeInterval intValue];
                int min = totalTimeInSeconds / 60;
                int sec = (totalTimeInSeconds % 60) / 5;
                self.durationText.text = [NSString stringWithFormat:@"%@:%@", [self.minArray objectAtIndex:min], [self.secArray objectAtIndex:sec]];
                
                [self.timePicker selectRow:min inComponent:0 animated:YES];
                [self.timePicker selectRow:sec inComponent:1 animated:YES];
                
                minutes = [NSString stringWithFormat:@"%02zd", min];
                seconds = [NSString stringWithFormat:@"%02zd", sec * 5];
            }
            
            [cell addSubview:title];
            [cell addSubview:self.durationText];
            
            break;
        }
        case 2:
        {
            // Reps
            title.text = @"Reps";
            self.repsText = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 80, 40)];
            self.repsStepperItem = [[UIStepper alloc] initWithFrame:CGRectMake(155, 20, 100, 40)];
            self.repsStepperItem.tintColor = themeNavBar4;
            [self.repsStepperItem addTarget:self action:@selector(repsStepper:) forControlEvents:UIControlEventValueChanged];
            
            [cell addSubview:title];
            [cell addSubview:self.repsText];
            [cell addSubview:self.repsStepperItem];
            
            // Sets
            UILabel *setsTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, 40, 40)];
            [setsTitle setFont:[UIFont boldSystemFontOfSize:18.0]];
            setsTitle.textColor = themeNavBar4;
            setsTitle.text = @"Sets";
            
            self.setsText = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 80, 40)];
            self.setsStepperItem = [[UIStepper alloc] initWithFrame:CGRectMake(155, 70, 100, 40)];
            self.setsStepperItem.tintColor = themeNavBar4;
            [self.setsStepperItem addTarget:self action:@selector(setsStepper:) forControlEvents:UIControlEventValueChanged];
            
            [cell addSubview:setsTitle];
            [cell addSubview:self.setsText];
            [cell addSubview:self.setsStepperItem];

            if (!createdNewExerciseSetting) {
                NSInteger repInt = [self.exerciseSetting.reps integerValue];
                NSInteger setInt = [self.exerciseSetting.sets integerValue];
                
                self.repsText.text = [NSString stringWithFormat: @"%02ld", (long)repInt];
                self.setsText.text = [NSString stringWithFormat: @"%02ld", (long)setInt];
            }
            
            break;
        }
        case 3:
        {
            title.text = @"Weight";

            self.weightText = [[UITextField alloc] initWithFrame:CGRectMake(150, 15, 100, 40)];
            self.weightText.textColor = themeNavBar4;
            self.weightText.layer.borderWidth = 1.0;
            self.weightText.layer.borderColor = themeNavBar4.CGColor;
            self.weightText.layer.borderWidth = 1.0;
            self.weightText.layer.cornerRadius = 8.0;
            self.weightText.textAlignment = NSTextAlignmentCenter;
            self.weightText.font = [UIFont systemFontOfSize:20.0];
            self.weightText.keyboardType = UIKeyboardTypeNumberPad;
            self.weightText.clearButtonMode = UITextFieldViewModeWhileEditing;
            self.weightText.placeholder = @"0";
            
            self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(255, 15, 25, 40)];
            self.unitLabel.textColor = themeNavBar4;
            
            
            // Set the units for weight from user defaults
            self.unitLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"units"];
            
            if (!createdNewExerciseSetting) {
                self.weightText.text = [NSString stringWithFormat:@"%d", [self.exerciseSetting.weight intValue]];
            }
            
            [cell addSubview:title];
            [cell addSubview:self.weightText];
            [cell addSubview:self.unitLabel];

            break;
        }
        case 4:
        {
            title.text = @"Note";
            [cell addSubview:title];

            
            
            break;
        }
        default:
        {
            break;
        }
    }

    // For rounded corner cells
    cell.layer.cornerRadius = 8.0f;
    cell.layer.masksToBounds = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    switch (indexPath.row) {
        case 0:
            // Select Exericse
            return 80.0;
            break;
        case 1:
            // Duration
            return 80.0;
            break;
        case 2:
            // Reps and Sets
            return 130.0;
            break;
        case 3:
            // Weight
            return 80.0;
            break;
        case 4:
            // Note
            return 140.0;
            break;
        default:
            break;
    }
    
    return 112.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"selectExercise" sender:self];
            break;
        default:
            break;
    }
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([segue.identifier isEqualToString:@"selectExercise"]) {
        AllExercisesTableViewController *allExercisesTableViewController = segue.destinationViewController;
        
        // Set the title of next controller
        allExercisesTableViewController.title = @"Select Exercise";
        // Hide the sidebar button
        allExercisesTableViewController.navigationItem.leftBarButtonItem = nil;
        
        // Set the delegate
        allExercisesTableViewController.delegate = self;
    }
}

#pragma mark - UIPickerViewDataSource

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
    //    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
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

/* Hide keyboard when empty space is touched */
-(void)dismissKeyboard {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    UIView *v = self.view;
    
    if ([v isEqual:0]) {
        NSLog(@"hello");
    }
    
    [self.view endEditing:YES];
}

#pragma mark - Bar buttons: done and cancel

- (IBAction)done:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    self.exerciseSetting.reps = [NSNumber numberWithInteger:[self.repsText.text integerValue]];
    self.exerciseSetting.sets = [NSNumber numberWithInteger:[self.setsText.text integerValue]];
    self.exerciseSetting.weight = [NSNumber numberWithInteger:[self.weightText.text integerValue]];
    self.exerciseSetting.timeInterval = [NSNumber numberWithDouble:nsTimeInterval];
    
    // Only need to set the index if it is a new ExerciseSetting- not when editting
    if (createdNewExerciseSetting) {
        int size = (int)[self.workout.exerciseGroup count];
        self.exerciseSetting.index = [NSNumber numberWithInt:size];
    }
    
    [self.workout addExerciseGroupObject:self.exerciseSetting];
    [self saveContext];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)cancel:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (createdNewExerciseSetting) {
        // Delete the newly created exercise entity
        [self.exerciseSetting deleteEntity];
    }
    
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

#pragma mark - Steppers for reps and sets

- (IBAction)repsStepper:(UIStepper *)sender {
    
    double value = [sender value];
    [self.repsText setText:[NSString stringWithFormat:@"%02d", (int)value] ];
}

- (IBAction)setsStepper:(UIStepper *)sender {
    
    double value = [sender value];
    [self.setsText setText:[NSString stringWithFormat:@"%02d", (int)value] ];
}

#pragma mark - AllExercisesTableViewControllerDelegate

// Pass the selected Exercise object
- (void)allExercisesViewControllerDidSelectWorkout:(AllExercisesTableViewController *)controller didSelectExercise:(Exercise *)exercise
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // display the selected exercise's name
    [self.selectedExerciseLabel setText:exercise.exerciseName];
    
    self.exerciseSetting.baseExercise = exercise;
    NSLog(@"%@", self.exerciseSetting.baseExercise);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
