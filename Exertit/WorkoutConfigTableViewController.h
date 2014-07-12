//
//  WorkoutConfigTableViewController.h
//  Exertit
//
//  Created by Lena Hsieh on 2014-06-29.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllExercisesTableViewController.h"
#import "ExerciseSetting.h"

@interface WorkoutConfigTableViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, AllExercisesTableViewControllerDelegate>

// Selected exercise
@property (strong) UILabel *selectedExerciseLabel;
@property (strong) UILabel *selectedExerciseArrow;

// Duration
@property (strong) UITextField *durationText;

// Reps and Sets
@property (strong) UILabel *repsText;
@property (strong) UILabel *setsText;
@property (strong) UIStepper *repsStepperItem;
@property (strong) UIStepper *setsStepperItem;
- (IBAction)repsStepper:(id)sender;
- (IBAction)setsStepper:(id)sender;

// Weight
@property (strong) UITextField *weightText;
@property (strong) UILabel *unitLabel;

// Clear and default buttons
@property (strong) UIButton *clearButton;
@property (strong) UIButton *defaultButton;

// Time picker view
@property (retain, nonatomic) NSMutableArray *secArray;
@property (retain, nonatomic) NSMutableArray *minArray;
@property (strong) UIPickerView *timePicker;

// Toolbar buttons
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@property (nonatomic, strong) Workout *workout;
@property (nonatomic, strong) ExerciseSetting *exerciseSetting;
@property (nonatomic, strong) Exercise *exercise;

@end
