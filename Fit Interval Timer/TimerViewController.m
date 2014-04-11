//
//  timerViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2013-12-30.
//  Copyright (c) 2013 hsieh. All rights reserved.
//

#import "TimerViewController.h"
#import "SWRevealViewController.h"

@interface TimerViewController ()

@end

static int minutesCount = 0;
static int secondsCount = 0;
static bool pauseTimer = 1;

@implementation TimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Slide out menu intialization
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    // Initialize time array with times value to pick from
    self.minArray = [[NSMutableArray alloc] init];
    self.secArray = [[NSMutableArray alloc] init];

    for (int j = 0; j < 60; j++) {
        [self.minArray addObject:[NSString stringWithFormat:@"%02d", j]];
    }
    
    for (int i = 0; i < 12; i++) {
        [self.secArray addObject:[NSString stringWithFormat:@"%02d", i*5]];
    }
    
    // Set the default setMin and setSec to zero
    self.setMin = 0;
    self.setSec = 0;
    
    // Default selected switcher is stopwatch
    self.selectedSwitcher = 0;
    [self.timePicker setUserInteractionEnabled:NO];
    [self.timePicker setAlpha:.6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* UIPickerViewDataSource */

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
        self.secDisplay.text = [self.secArray objectAtIndex:row];
        secondsCount = [self.secDisplay.text intValue];
        self.setSec = secondsCount;
    } else {
        self.minDisplay.text = [self.minArray objectAtIndex:row];
        minutesCount = [self.minDisplay.text intValue];
        self.setMin = minutesCount;
    }
}

/* START and RESET button actions */

- (IBAction)startTimer:(id)sender {
    
    // Timer- don't change label if min and sec are zeros
    if (self.selectedSwitcher == 1) {
        if (self.setMin == 0 && self.setSec == 0) {
            return;
        }
    }
    
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

- (IBAction)resetTimer:(id)sender {
    // Stop the timer
    [self.secondsTimer invalidate];
    self.secondsTimer = nil;
    
    if (self.selectedSwitcher == 0) {
        // Stopwatch
        minutesCount = 0;
        secondsCount = 0;
    } else {
        // Set the timer back to the selected min and sec
        minutesCount = self.setMin;
        secondsCount = self.setSec;
    }

    // Reset the min and sec display
    [self displayMinValue:minutesCount andSecValue:secondsCount];
    
    // Change back to START label and the pauseTimer boolean to 1
    [self.startLabel setTitle:@"START" forState:UIControlStateNormal];
    pauseTimer = 1;
}

// Called every second when timePicker is active
- (void)timer {
    if (self.selectedSwitcher == 0) {
        // Stopwatch
        if (secondsCount == 59) {
            minutesCount++;
            secondsCount = 0;
        } else {
            secondsCount++;
        }
    } else {
        // Timer
        if (secondsCount == 0 && minutesCount == 0) {
            [self.secondsTimer invalidate];
            self.secondsTimer = nil;
            
        } else if (secondsCount == 0) {
            minutesCount--;
            secondsCount = 59;
        } else {
            secondsCount--;
        }
    }
    
    [self displayMinValue:minutesCount andSecValue:secondsCount];
}

// Segmented control: stopwatch and timer
- (IBAction)indexChanged:(id)sender {
    
    // Must stop timer first
    [self.secondsTimer invalidate];
    self.secondsTimer = nil;
    
    switch (self.switcher.selectedSegmentIndex)
    {
        case 0:
            // stopwatch
            self.selectedSwitcher = 0;
            [self.timePicker setUserInteractionEnabled:NO];
            [self.timePicker setAlpha:.6];
            minutesCount = 0;
            secondsCount = 0;
            break;
        case 1:
            // timer
            self.selectedSwitcher = 1;
            [self.timePicker setUserInteractionEnabled:YES];
            [self.timePicker setAlpha:1];
            minutesCount = self.setMin;
            secondsCount = self.setSec;
            break;
        default:
            break;
    }
    
    pauseTimer = 1;

    [self displayMinValue:minutesCount andSecValue:secondsCount];
    [self.startLabel setTitle:@"START" forState:UIControlStateNormal];
}

// Change the display values for the min and sec labels
-(void)displayMinValue:(int)minutes andSecValue:(int)seconds {
    self.minDisplay.text = [NSString stringWithFormat:@"%02d", minutes];
    self.secDisplay.text = [NSString stringWithFormat:@"%02d", seconds];
}

@end
