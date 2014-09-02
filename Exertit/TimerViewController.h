//
//  timerViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2013-12-30.
//  Copyright (c) 2013 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

// Array of the sec and min values
@property (retain, nonatomic) NSMutableArray *secArray;
@property (retain, nonatomic) NSMutableArray *minArray;

// Store the set values for min and sec
@property (nonatomic, assign) int setMin;
@property (nonatomic, assign) int setSec;

// Labels for min and sec
@property (strong, nonatomic) IBOutlet UILabel *minDisplay;
@property (weak, nonatomic) IBOutlet UILabel *colonDisplay;
@property (strong, nonatomic) IBOutlet UILabel *secDisplay;
@property (weak, nonatomic) IBOutlet UILabel *dotDisplay;
@property (weak, nonatomic) IBOutlet UILabel *milliDisplay;

// Time picker
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;

// Timer
@property (nonatomic, strong) NSTimer *secondsTimer;

// Segmented control: stopwatch and timer
@property (nonatomic, assign) int selectedSwitcher;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switcher;

// Start and Reset button labels
@property (weak, nonatomic) IBOutlet UIButton *startLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetLabel;

- (IBAction)startTimer:(id)sender;
- (IBAction)resetTimer:(id)sender;
- (IBAction)indexChanged:(id)sender;

@end
