//
//  NewWorkoutViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-02.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"

@class NewWorkoutViewController;

@protocol NewWorkoutViewControllerDelegate <NSObject>
- (void)newWorkoutViewControllerDidCancel:(NewWorkoutViewController *)controller;
- (void)newWorkoutViewController:(NewWorkoutViewController *)controller;
@end

@interface NewWorkoutViewController : UITableViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <NewWorkoutViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *durationTextField;

// Time picker view
@property (retain, nonatomic) NSMutableArray *secArray;
@property (retain, nonatomic) NSMutableArray *minArray;
@property (strong, nonatomic) IBOutlet UIPickerView *timePicker;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@end
