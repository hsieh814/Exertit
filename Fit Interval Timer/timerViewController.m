//
//  timerViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2013-12-30.
//  Copyright (c) 2013 hsieh. All rights reserved.
//

#import "timerViewController.h"

@interface timerViewController ()

@end

static int minutesCount = 0;
static int secondsCount = 0;
static bool pauseTimer = 0;

@implementation timerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Initialize time array with times value to pick from
    self.minArray = [[NSMutableArray alloc] init];
    self.secArray = [[NSMutableArray alloc] init];

    for (int j = 0; j < 60; j++) {
        [self.minArray addObject:[NSString stringWithFormat:@"%d", j]];
    }
    
    for (int i = 0; i < 12; i++) {
        [self.secArray addObject:[NSString stringWithFormat:@"%d", i*5]];
    }
    
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
        //return [NSString stringWithFormat:@"%@/%@", [self.secArray objectAtIndex:row], @" sec"];
        return [self.secArray objectAtIndex:row];
    } else {
        return [self.minArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 1) {
        self.secTime.text = [self.secArray objectAtIndex:row];
    } else {
        self.minTime.text = [self.minArray objectAtIndex:row];
    }
}

/* START and STOP button actions */

- (IBAction)startTimer:(id)sender {
    
    self.secondsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target: self
                                                       selector:@selector(decrementTimer)
                                                       userInfo:nil
                                                        repeats:YES];
    secondsCount = [self.secTime.text intValue];
    minutesCount = [self.minTime.text intValue];
    self.minDisplay.text = [NSString stringWithFormat:@"%02d", minutesCount];
    self.secDisplay.text = [NSString stringWithFormat:@"%02d", secondsCount];
    
//    [(UIButton *)sender setHidden:YES];
    
}

- (IBAction)stopTimer:(id)sender {

    if (pauseTimer) {
        self.secondsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                             target: self
                                                           selector:@selector(decrementTimer)
                                                           userInfo:nil
                                                            repeats:YES];
        pauseTimer = 0;
        NSLog(@"Resume");
    } else {
        [self.secondsTimer invalidate];
        self.secondsTimer = nil;
        pauseTimer = 1;
        NSLog(@"stop");
    }
}

- (void)decrementTimer {
    // Finish count-down
    if (secondsCount == 0 && minutesCount == 0) {
        [self.secondsTimer invalidate];
        self.secondsTimer = nil;
        
    } else if (secondsCount == 0) {
        minutesCount--;
        secondsCount = 59;
    } else {
        secondsCount--;
    }
    
    self.minDisplay.text = [NSString stringWithFormat:@"%02d", minutesCount];
    self.secDisplay.text = [NSString stringWithFormat:@"%02d", secondsCount];

}

@end
