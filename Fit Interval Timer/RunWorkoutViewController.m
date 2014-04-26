//
//  RunWorkoutViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-26.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "RunWorkoutViewController.h"

@interface RunWorkoutViewController ()

@end

@implementation RunWorkoutViewController

int exerciseIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    exerciseIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTimer:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

}

- (IBAction)decrementReps:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

}

- (IBAction)decrementSets:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

}

// Navigation bar 'x' - stop the workout
- (IBAction)stopWorkout:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
