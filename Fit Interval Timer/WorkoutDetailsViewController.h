//
//  WorkoutDetailsViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-02.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"

@class WorkoutDetailsViewController;

@protocol WorkoutDetailsViewControllerDelegate <NSObject>
- (void)workoutDetailsViewControllerDidCancel:(WorkoutDetailsViewController *)controller;
- (void)workoutDetailsViewController:(WorkoutDetailsViewController *)controller didAddWorkout:(Workout *)workout;
@end

@interface WorkoutDetailsViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <WorkoutDetailsViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *durationTextField;

// Time picker view
@property (retain, nonatomic) NSMutableArray *secArray;
@property (retain, nonatomic) NSMutableArray *minArray;
@property (strong, nonatomic) IBOutlet UIPickerView *timePicker;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
