//
//  IntervalTimerTableViewController.h
//  Exertit
//
//  Created by Lena Hsieh on 2014-08-10.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultCell.h"

@interface IntervalTimerTableViewController : UITableViewController <UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

// Bar buttons
@property (strong, nonatomic) UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) UIBarButtonItem *defaultButton;

// Time picker view
@property (strong, nonatomic) IBOutlet UIPickerView *timePicker;
@property (retain, nonatomic) NSMutableArray *secArray;
@property (retain, nonatomic) NSMutableArray *minArray;

// Cells
@property (weak, nonatomic) IBOutlet UITableViewCell *cell1;
@property (weak, nonatomic) IBOutlet DefaultCell *cell2;
@property (weak, nonatomic) IBOutlet DefaultCell *cell3;
@property (weak, nonatomic) IBOutlet DefaultCell *cell4;

// Textfields
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UITextField *warmupDuration;
@property (weak, nonatomic) IBOutlet UITextField *lowIntervalDuration;
@property (weak, nonatomic) IBOutlet UITextField *highIntervalDuration;
@property (weak, nonatomic) IBOutlet UITextField *repetitions;
@property (weak, nonatomic) IBOutlet UITextField *cooldownDuration;

- (IBAction)startIntervalTimer:(id)sender;
- (IBAction)setWarmup:(id)sender;
- (IBAction)setLowInterval:(id)sender;
- (IBAction)setHighInterval:(id)sender;
- (IBAction)setRepetitionsNumber:(id)sender;
- (IBAction)setCooldown:(id)sender;

@end
