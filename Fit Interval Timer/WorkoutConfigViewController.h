//
//  WorkoutConfigViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2/16/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"
#import "AllExercisesTableViewController.h"
#import "ExerciseCell.h"
#import "ExerciseSetting.h"

@interface WorkoutConfigViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, AllExercisesTableViewControllerDelegate>

// Selected exercise
@property (weak, nonatomic) IBOutlet UIButton *selectedExerciseButton;

// Duration
@property (weak, nonatomic) IBOutlet UITextField *durationText;

// Reps and Sets
@property (weak, nonatomic) IBOutlet UILabel *repsText;
@property (weak, nonatomic) IBOutlet UILabel *setsText;
@property (weak, nonatomic) IBOutlet UIStepper *repsStepperItem;
@property (weak, nonatomic) IBOutlet UIStepper *setsStepperItem;
- (IBAction)repsStepper:(UIStepper *)sender;
- (IBAction)setsStepper:(UIStepper *)sender;

// Weight
@property (weak, nonatomic) IBOutlet UITextField *weightLabel;

// Time picker view
@property (retain, nonatomic) NSMutableArray *secArray;
@property (retain, nonatomic) NSMutableArray *minArray;
@property (strong, nonatomic) IBOutlet UIPickerView *timePicker;

// Toolbar buttons
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@property (nonatomic, strong) Workout *workout;
@property (nonatomic, strong) ExerciseSetting *exerciseSetting;

@end
