//
//  NewWorkoutViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-20.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"

@interface NewWorkoutViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (nonatomic, strong) Workout *workout;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
