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

// selectedSwitcher
static const int STOPWATCH = 0;
static const int TIMER = 1;

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
    self.selectedSwitcher = STOPWATCH;
    [self enableTimePicker:NO];
    
    // Color and text customization
    [self.startLabel setTitleColor:appleGreen forState:UIControlStateNormal];
    [self.resetLabel setTitleColor:appleBlue forState:UIControlStateNormal];
    self.switcher.tintColor = themeNavBar4;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16], NSFontAttributeName, nil];
    [self.switcher setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    // Cicle button
    self.startLabel.layer.cornerRadius = self.startLabel.bounds.size.width/2.0;
    self.startLabel.layer.borderWidth = 1.0;
    self.startLabel.layer.borderColor = self.startLabel.titleLabel.textColor.CGColor;
    self.resetLabel.layer.cornerRadius = self.resetLabel.bounds.size.width/2.0;
    self.resetLabel.layer.borderWidth = 1.0;
    self.resetLabel.layer.borderColor = self.resetLabel.titleLabel.textColor.CGColor;
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
    if (component == 1) {
        self.secDisplay.text = [self.secArray objectAtIndex:(row % [self.secArray count])];
        secondsCount = [self.secDisplay.text intValue];
        self.setSec = secondsCount;
    } else {
        self.minDisplay.text = [self.minArray objectAtIndex:(row % [self.minArray count])];
        minutesCount = [self.minDisplay.text intValue];
        self.setMin = minutesCount;
    }
}

// Enable or diable the time picker
- (void)enableTimePicker:(bool)isEnable
{
    double transparency;
    if (isEnable) {
        transparency = 1.0;
    } else {
        transparency = 0.3;
    }
    
    [self.timePicker setUserInteractionEnabled:isEnable];
    [self.timePicker setAlpha:transparency];
}

/* START and RESET button actions */

- (IBAction)startTimer:(id)sender {
    
    // Timer- don't change label if min and sec are zeros
    if (self.selectedSwitcher == TIMER) {
        if (self.setMin == 0 && self.setSec == 0) {
            return;
        }
    }
    
    if (pauseTimer) {
        // Change label to PAUSE
        [self.startLabel setTitle:@"PAUSE" forState:UIControlStateNormal];
        
        [self runTimer];
        
        pauseTimer = FALSE;
        
        // Disable the time picker
        [self enableTimePicker:NO];
        
    } else {
        [self stopRunningTimer];

        // Change label to RESUME
        [self.startLabel setTitle:@"RESUME" forState:UIControlStateNormal];
    }
}

- (IBAction)resetTimer:(id)sender {
    // Stop the timer
    [self stopRunningTimer];
    [self.startLabel setTitle:@"START" forState:UIControlStateNormal];
    
    if (self.selectedSwitcher == STOPWATCH) {
        // Stopwatch
        minutesCount = 0;
        secondsCount = 0;
    } else {
        // Set the timer back to the selected min and sec
        minutesCount = self.setMin;
        secondsCount = self.setSec;
        
        // Enable the time picker
        [self enableTimePicker:YES];
    }

    // Reset the min and sec display
    [self displayMinValue:minutesCount andSecValue:secondsCount];
}

// Called every second when timePicker is active
- (void)timer {
    if (self.selectedSwitcher == STOPWATCH) {
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
            [self stopRunningTimer];
            [self.startLabel setTitle:@"START" forState:UIControlStateNormal];

            minutesCount = self.setMin;
            secondsCount = self.setSec;
            [self displayMinValue:minutesCount andSecValue:secondsCount];

            [self enableTimePicker:TRUE];
            
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
    [self stopRunningTimer];
    [self.startLabel setTitle:@"START" forState:UIControlStateNormal];

    switch (self.switcher.selectedSegmentIndex)
    {
        case 0:
            // stopwatch
            self.selectedSwitcher = STOPWATCH;
            [self enableTimePicker:NO];
            minutesCount = 0;
            secondsCount = 0;
            break;
        case 1:
            // timer
            self.selectedSwitcher = TIMER;
            [self enableTimePicker:YES];
            minutesCount = self.setMin;
            secondsCount = self.setSec;
            break;
        default:
            break;
    }
    
    [self displayMinValue:minutesCount andSecValue:secondsCount];
}

// Change the display values for the min and sec labels
-(void)displayMinValue:(int)minutes andSecValue:(int)seconds {
    self.minDisplay.text = [NSString stringWithFormat:@"%02d", minutes];
    self.secDisplay.text = [NSString stringWithFormat:@"%02d", seconds];
}

// Run the timer
-(void)runTimer
{
    self.secondsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target: self
                                                       selector:@selector(timer)
                                                       userInfo:nil
                                                        repeats:YES];
}

// Stop the timer
-(void)stopRunningTimer
{
    [self.secondsTimer invalidate];
    self.secondsTimer = nil;
    
    pauseTimer = TRUE;
}

@end
