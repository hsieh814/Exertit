//
//  NewExerciseViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/17/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

@class NewExerciseViewController;

@class Exercise;

@protocol NewExerciseViewControllerDelegate <NSObject>
- (void)newExerciseViewControllerDidCancel:(NewExerciseViewController *)controller;
- (void)newExerciseViewControllerDidSave:(NewExerciseViewController *)controller;
@end

@interface NewExerciseViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <NewExerciseViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *exerciseNameTextField;
@property (nonatomic, strong) Exercise *exercise;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end

