//
//  RunIntervalTrainerViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-19.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunIntervalTrainerViewController : UIViewController

// Timer
@property (nonatomic, strong) NSTimer *secondsTimer;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *minDisplay;
@property (weak, nonatomic) IBOutlet UILabel *secDisplay;
@property (weak, nonatomic) IBOutlet UILabel *currentRep;
@property (weak, nonatomic) IBOutlet UILabel *totalRep;
@property (weak, nonatomic) IBOutlet UIButton *pauseLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetLabel;

@property (strong, nonatomic) NSString *warmupDuration, *lowIntervalDuration, *highIntervalDuration, *cooldownDuration, *repetitions;

- (IBAction)pauseTimer:(id)sender;
- (IBAction)resetTimer:(id)sender;

@end
