//
//  NewExerciseViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-20.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "NewExerciseViewController.h"
#import "Exercise.h"

@interface NewExerciseViewController ()

@end

@implementation NewExerciseViewController

bool createNewExercise;

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
    
    // Create an exercise with MagicalRecord if it does not exist
    // exercise may exist if editing a existing one
    if (!self.exercise) {
        self.exercise = [Exercise createEntity];
        createNewExercise = YES;
    } else {
        createNewExercise = NO;
    }
    
    // Set the attributes to the corresponding areas
    self.exerciseNameTextField.text = self.exercise.exerciseName;
    
    // Color customization
    self.view.backgroundColor = lightBlue;
    self.exerciseNameLabel.textColor = themeNavBar4;
    self.exerciseNameTextField.textColor = themeNavBar4;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Save data */
- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}

- (IBAction)done:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([self.exerciseNameTextField.text isEqualToString:@""]) {
        // don't save exercise since empty name
        [self.exercise deleteEntity];
    } else {
        self.exercise.exerciseName = self.exerciseNameTextField.text;
    }
    
    // save the context
    [self saveContext];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (createNewExercise) {
        // Delete the newly created exercise
        [self.exercise deleteEntity];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
