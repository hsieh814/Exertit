//
//  IntervalTimerTableViewController.m
//  Exertit
//
//  Created by Lena Hsieh on 2014-08-10.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "IntervalTimerTableViewController.h"
#import "SWRevealViewController.h"
#import "DefaultCell.h"
#import "RunIntervalTrainerViewController.h"

@interface IntervalTimerTableViewController ()

@end

@implementation IntervalTimerTableViewController

UIToolbar *pickerToolbar;
NSString *seconds;
NSString *minutes;
UITextField *selectedTextField;
bool isSetWarmup, isSetLowInterval, isSetHighInterval, isSetCooldown, isSetRepetition;

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
    
    // Slide out menu customization
    _sidebarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"slide_menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = _sidebarButton;
    
    // Default bar button
    _defaultButton = [[UIBarButtonItem alloc]initWithTitle:@"Default" style:UIBarButtonItemStylePlain target:self action:@selector(setDefault:)];
    self.navigationItem.rightBarButtonItem = _defaultButton;

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
    self.timePicker = [[UIPickerView alloc] init];
    self.timePicker.showsSelectionIndicator = YES;
    self.timePicker.delegate = self;
    self.timePicker.dataSource = self;
    self.timePicker.backgroundColor = [UIColor whiteColor];
    
    // Fool user with circular time picker
    [self.timePicker selectRow:(10 * [self.secArray count]) inComponent:1 animated:NO];
    [self.timePicker selectRow:(10 * [self.minArray count]) inComponent:0 animated:NO];

    self.warmupDuration.inputView = self.timePicker;
    self.lowIntervalDuration.inputView = self.timePicker;
    self.highIntervalDuration.inputView = self.timePicker;
    self.cooldownDuration.inputView = self.timePicker;
    
    // Done bar button
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone)];
    pickerToolbar.items = [NSArray arrayWithObjects:space, done, nil];
    
    self.warmupDuration.inputAccessoryView = pickerToolbar;
    self.lowIntervalDuration.inputAccessoryView = pickerToolbar;
    self.highIntervalDuration.inputAccessoryView = pickerToolbar;
    self.cooldownDuration.inputAccessoryView = pickerToolbar;
    
    // View customization
    self.title = @"Interval Trainer";
    
    // Rounded corners for cells
    [self cellCustomization];
    
    // TableView customization
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = mediumBlue;
    
    // Change start button text color
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startButton.layer.borderColor = appleGreen.CGColor;
    self.startButton.layer.borderWidth = 2.0;
    self.startButton.layer.cornerRadius = 20.0f;
    self.startButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.startButton setTitleColor:appleGreen forState:UIControlStateNormal];
    self.startButton.backgroundColor = [UIColor whiteColor];
    
    // Change the textfields' border color
    [self changeTextFieldBorderAndTextColor];
    
    self.warmupDuration.delegate = self;
    self.lowIntervalDuration.delegate = self;
    self.highIntervalDuration.delegate = self;
    self.cooldownDuration.delegate = self;
    self.repetitions.delegate = self;
    
    // Set the textfields' text to default value saved
    [self getDefaultTextFieldData];
    
    // Set the textfield values as set
    isSetWarmup = isSetLowInterval = isSetHighInterval = isSetCooldown = isSetRepetition = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Blue background for cell1 and rounded corners for the rest
- (void)cellCustomization {
    self.cell1.backgroundColor = mediumBlue;
    // Tap recognizer to dismiss keyboard when a cell is tapped
    UITapGestureRecognizer *gestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.cell1 addGestureRecognizer:gestureRecognizer1];
    
    self.cell2.layer.cornerRadius = 8.0f;
    self.cell2.layer.masksToBounds = YES;
    // Change spacing between DefaultCell (increase gap)
    [self.cell2 setDefaultHeightBorder:4];
    [self.cell2 setDefaultWidthBorder:10];
    UITapGestureRecognizer *gestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.cell2 addGestureRecognizer:gestureRecognizer2];
    
    self.cell3.layer.cornerRadius = 8.0f;
    self.cell3.layer.masksToBounds = YES;
    [self.cell3 setDefaultHeightBorder:4];
    [self.cell3 setDefaultWidthBorder:10];
    UITapGestureRecognizer *gestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.cell3 addGestureRecognizer:gestureRecognizer3];
    
    self.cell4.layer.cornerRadius = 8.0f;
    self.cell4.layer.masksToBounds = YES;
    [self.cell4 setDefaultHeightBorder:4];
    [self.cell4 setDefaultWidthBorder:10];
    UITapGestureRecognizer *gestureRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.cell4 addGestureRecognizer:gestureRecognizer4];
}

/* Change all the textfields' border color */
-(void)changeTextFieldBorderAndTextColor
{
    for (UITextField *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [[subView layer] setBorderColor:[grey CGColor]];
            subView.layer.borderWidth= 1.0f;
            subView.layer.cornerRadius = 8.0f;
        }
    }
    
    self.warmupDuration.textColor = self.lowIntervalDuration.textColor = self.highIntervalDuration.textColor
    = self.cooldownDuration.textColor = self.repetitions.textColor = grey;
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([segue.identifier isEqualToString:@"RunInterval"]) {
        RunIntervalTrainerViewController *runIntervalTrainerViewController = segue.destinationViewController;
        
        // Pass the textfield's duration values
        runIntervalTrainerViewController.warmupDuration = self.warmupDuration.text;
        runIntervalTrainerViewController.lowIntervalDuration = self.lowIntervalDuration.text;
        runIntervalTrainerViewController.highIntervalDuration = self.highIntervalDuration.text;
        runIntervalTrainerViewController.cooldownDuration = self.cooldownDuration.text;
        runIntervalTrainerViewController.repetitions = self.repetitions.text;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Return the number of rows in the section.
    return 4;
}

- (IBAction)dismissKeyboard:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Dismiss keyboards
    [self.view endEditing:YES];
}

#pragma mark - Picker delegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    // 2 columns: min and sec
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Fool user with circular time picker by setting the number of rows to a large numnber
    if (component == 1) {
        return [self.secArray count] * 20;
    } else {
        return [self.minArray count] * 20;
    }
}

/* UIPickerViewDelegate */

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Circular time picker- jump back to middle if user reaches end of picker
    if (component == 1) {
        if (row == 0 || row == ([self.secArray count] * 20 -1)) {
            [self.timePicker selectRow:(5 * [self.secArray count]) inComponent:1 animated:YES];
        }
        return [self.secArray objectAtIndex:(row % [self.secArray count])];
    } else {
        if (row == 0 || row == ([self.minArray count] * 20 -1)) {
            [self.timePicker selectRow:(5 * [self.minArray count]) inComponent:0 animated:YES];
        }
        return [self.minArray objectAtIndex:(row % [self.minArray count])];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (component == 1) {
        seconds = [self.secArray objectAtIndex:(row % [self.secArray count])];
    } else {
        minutes = [self.minArray objectAtIndex:(row % [self.minArray count])];
    }
}

// Time picker Done button
-(void)pickerDone {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (seconds == NULL) {
        seconds = @"00";
    }
    if (minutes == NULL) {
        minutes = @"00";
    }
    
    if ([self.warmupDuration isFirstResponder]) {
        selectedTextField = self.warmupDuration;
    } else if ([self.lowIntervalDuration isFirstResponder]) {
        selectedTextField = self.lowIntervalDuration;
    } else if ([self.highIntervalDuration isFirstResponder]) {
        selectedTextField = self.highIntervalDuration;
    } else if ([self.cooldownDuration isFirstResponder]) {
        selectedTextField = self.cooldownDuration;
    } else if ([self.repetitions isFirstResponder]) {
        selectedTextField = self.repetitions;
    }
    
    selectedTextField.text = [NSString stringWithFormat:@"%@:%@", minutes, seconds];
    [selectedTextField resignFirstResponder];
}

#pragma mark - User Defaults

/* Save the textfields' text as default */
- (IBAction)setDefault:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.warmupDuration.text forKey:@"warmup"];
    [defaults setObject:self.lowIntervalDuration.text forKey:@"lowInterval"];
    [defaults setObject:self.highIntervalDuration.text forKey:@"highInterval"];
    [defaults setObject:self.cooldownDuration.text forKey:@"cooldown"];
    [defaults setObject:self.repetitions.text forKey:@"repetitions"];
    
    [defaults synchronize];
}

/* Get the saved default textfields' text */
- (void)getDefaultTextFieldData
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.warmupDuration.text = [defaults objectForKey:@"warmup"];
    self.lowIntervalDuration.text = [defaults objectForKey:@"lowInterval"];
    self.highIntervalDuration.text = [defaults objectForKey:@"highInterval"];
    self.cooldownDuration.text = [defaults objectForKey:@"cooldown"];
    self.repetitions.text = [defaults objectForKey:@"repetitions"];
}

/* Check if all the textfields have valid text, then enable the start button */
- (void)enableStartButton {
    if (isSetWarmup && isSetLowInterval && isSetHighInterval && isSetCooldown && isSetRepetition) {
        [self.startButton setEnabled:YES];
        self.startButton.alpha = 1.0;
    } else {
        [self.startButton setEnabled:NO];
        // Manually gray out the START button
        self.startButton.alpha = 0.3;
    }
}

- (IBAction)startIntervalTimer:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self performSegueWithIdentifier:@"RunInterval" sender:self];
}

- (IBAction)setWarmup:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([self.warmupDuration.text isEqualToString:@""]) {
        isSetWarmup = NO;
    } else {
        isSetWarmup = YES;
    }
    [self enableStartButton];
}

- (IBAction)setLowInterval:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([self.lowIntervalDuration.text isEqualToString:@""] || [self.lowIntervalDuration.text isEqualToString:@"00:00"]) {
        isSetLowInterval = NO;
    } else {
        isSetLowInterval = YES;
    }
    [self enableStartButton];
}

- (IBAction)setHighInterval:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([self.highIntervalDuration.text isEqualToString:@""] || [self.highIntervalDuration.text isEqualToString:@"00:00"]) {
        isSetHighInterval = NO;
    } else {
        isSetHighInterval = YES;
    }
    [self enableStartButton];
}

- (IBAction)setRepetitionsNumber:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    int repetitionText = [self.repetitions.text intValue];
    if ([self.repetitions.text isEqualToString:@""] || repetitionText == 0) {
        isSetRepetition = NO;
    } else {
        isSetRepetition = YES;
    }
    [self enableStartButton];
}

- (IBAction)setCooldown:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([self.cooldownDuration.text isEqualToString:@""]) {
        isSetCooldown = NO;
    } else {
        isSetCooldown = YES;
    }
    [self enableStartButton];
}

@end
