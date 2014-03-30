//
//  NewExerciseViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/17/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "NewExerciseViewController.h"
#import "Exercise.h"

@interface NewExerciseViewController ()

@end

@implementation NewExerciseViewController

//timerAppDelegate *appDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    self = [super initWithStyle:style];
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
    }
    // Set the attributes to the corresponding areas
    self.exerciseNameTextField.text = self.exercise.exerciseName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Touch row to add text
    if (indexPath.section == 0) {
        [self.exerciseNameTextField becomeFirstResponder];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([textField.text length] > 0) {
        self.title = textField.text;
        self.exercise.exerciseName = textField.text;	}
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

/* Bar buttons: cancel and done */

- (IBAction)cancel:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Delete the newly created exercise
    [self.exercise deleteEntity];
    
    // modal segue
    [self dismissModalViewControllerAnimated:YES];
}
                
- (IBAction)done:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    self.exercise.exerciseName = self.exerciseNameTextField.text;
    
    // save the context
    [self saveContext];

    [self dismissModalViewControllerAnimated:YES];

}

@end
