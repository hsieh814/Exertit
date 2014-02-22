//
//  WorkoutConfigViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2/16/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

@class WorkoutConfigViewController;

@protocol WorkoutConfigViewControllerDelegate <NSObject>
- (void)workoutConfigViewControllerDidCancel:(WorkoutConfigViewController *)controller;
- (void)workoutConfigViewController:(WorkoutConfigViewController *)controller didAddExercise:(Exercise *)exercise;
@end

@interface WorkoutConfigViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

// Delegate
@property (nonatomic, weak) id <WorkoutConfigViewControllerDelegate> delegate;

// Selected exercise
@property (weak, nonatomic) IBOutlet UITableViewCell *selectedExercise;

// Duration
@property (weak, nonatomic) IBOutlet UITextField *durationText;

// Reps and Sets
@property (weak, nonatomic) IBOutlet UILabel *repsText;
@property (weak, nonatomic) IBOutlet UILabel *setsText;
@property (weak, nonatomic) IBOutlet UIStepper *repsSelector;
@property (weak, nonatomic) IBOutlet UIStepper *setsSelector;

// Time picker view
@property (retain, nonatomic) NSMutableArray *secArray;
@property (retain, nonatomic) NSMutableArray *minArray;
@property (strong, nonatomic) IBOutlet UIPickerView *timePicker;

// Toolbar buttons
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
