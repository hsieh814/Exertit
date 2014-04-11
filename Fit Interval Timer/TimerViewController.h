//
//  timerViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2013-12-30.
//  Copyright (c) 2013 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

// Array of the sec and min values
@property (retain, nonatomic) NSMutableArray *secArray;
@property (retain, nonatomic) NSMutableArray *minArray;

// Store the set values for min and sec
@property (nonatomic, assign) int setMin;
@property (nonatomic, assign) int setSec;

// Label for min and sec
@property (strong, nonatomic) IBOutlet UILabel *minDisplay;
@property (strong, nonatomic) IBOutlet UILabel *secDisplay;

// Time picker
@property (strong, nonatomic) IBOutlet UIPickerView *time_picker;
@property (nonatomic, strong) NSTimer *secondsTimer;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

// Start and Reset button labels
@property (weak, nonatomic) IBOutlet UIButton *startLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetLabel;

- (IBAction)startTimer:(id)sender;
- (IBAction)resetTimer:(id)sender;

@end
