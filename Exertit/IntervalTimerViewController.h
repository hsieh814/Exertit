//
//  IntervalTimerViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/5/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface IntervalTimerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

// Time picker view
@property (strong, nonatomic) IBOutlet UIPickerView *timePicker;
@property (retain, nonatomic) NSMutableArray *secArray;
@property (retain, nonatomic) NSMutableArray *minArray;

// Scroll view
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// Textfields
@property (weak, nonatomic) IBOutlet UITextField *warmupTextField;
@property (weak, nonatomic) IBOutlet UITextField *lowIntervalTextField;
@property (weak, nonatomic) IBOutlet UITextField *highIntervalTextField;
@property (weak, nonatomic) IBOutlet UITextField *cooldownTextField;
@property (weak, nonatomic) IBOutlet UITextField *repetitionsTextField;

@property (weak, nonatomic) IBOutlet UITextField *warmupDuration;
@property (weak, nonatomic) IBOutlet UITextField *lowIntervalDuration;
@property (weak, nonatomic) IBOutlet UITextField *highIntervalDuration;
@property (weak, nonatomic) IBOutlet UITextField *cooldownDuration;
@property (weak, nonatomic) IBOutlet UITextField *repetitions;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

- (IBAction)setWarmup:(id)sender;
- (IBAction)setLowInterval:(id)sender;
- (IBAction)setHighInterval:(id)sender;
- (IBAction)setCooldown:(id)sender;
- (IBAction)setRepetitionsNumber:(id)sender;
- (IBAction)startIntervalTimer:(id)sender;
- (IBAction)setDefault:(id)sender;

@end