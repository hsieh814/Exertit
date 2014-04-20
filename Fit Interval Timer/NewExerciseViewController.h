//
//  NewExerciseViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-20.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"

@interface NewExerciseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *exerciseNameTextField;

@property (nonatomic, strong) Exercise *exercise;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
