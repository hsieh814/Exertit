//
//  timerViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2013-12-30.
//  Copyright (c) 2013 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *time_picker;

@property (strong, nonatomic) IBOutlet UILabel *minTime;
@property (strong, nonatomic) IBOutlet UILabel *secTime;

@property (retain, nonatomic) NSMutableArray *secArray;
@property (retain, nonatomic) NSMutableArray *minArray;

@property (strong, nonatomic) IBOutlet UILabel *minDisplay;
@property (strong, nonatomic) IBOutlet UILabel *secDisplay;

@property (nonatomic, strong) NSTimer *secondsTimer;

- (IBAction)startTimer:(id)sender;
- (IBAction)stopTimer:(id)sender;

@end
