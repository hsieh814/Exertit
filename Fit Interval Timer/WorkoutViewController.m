//
//  WorkoutViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2/15/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "WorkoutViewController.h"
#import "Workout.h"
#import "Exercise.h"
#import "ExerciseSetting.h"
#import "SWRevealViewController.h"
#import "RunWorkoutViewController.h"

@interface WorkoutViewController ()

@end

@implementation WorkoutViewController

- (id)initWithStyle:(UITableViewStyle)style
{
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
    
    // Long press gesture for moving table cells
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
    
    // Change start button text color
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startButton.backgroundColor = appleGreen;
    self.startButton.layer.borderColor = appleGreen.CGColor;
    self.startButton.layer.borderWidth = 1.0;
    self.startButton.layer.cornerRadius = 8.0f;
    
    // TableView customization
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = lightBlue;
    
    // Make tableview start lower
//    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
//    self.tableView.contentInset = inset;
    
//    // This will remove extra separators from tableview
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

// called everytime we enter the view
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Fetch all exercises
    [self fetchAllExercisesForWorkout];
    
    // Reload table
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Return the number of rows in the section.
    return self.exercisesForWorkout.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    ExerciseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell" forIndexPath:indexPath];
    ExerciseSetting *exerciseSetting = [self.exercisesForWorkout objectAtIndex:indexPath.row];
    if (exerciseSetting.baseExercise == nil) {
        [exerciseSetting deleteEntity];
        [self saveContext];
        
        [self.exercisesForWorkout removeObjectAtIndex:indexPath.row];
    } else {
        cell.exerciseName.text = exerciseSetting.baseExercise.exerciseName;
    }
    cell.exerciseName.textColor = themeNavBar4;

    // Cell customization
    cell.layer.cornerRadius = 8.0f;
    cell.layer.masksToBounds = YES;
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ExerciseSetting *exerciseSettingToRemove = self.exercisesForWorkout[indexPath.row];
        [exerciseSettingToRemove deleteEntity];
        [self saveContext];
        
        [self.exercisesForWorkout removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self enableOrDisableStartButton];
    }
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // index of the selected row
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *navController = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"AddExercise"]) {
        
        WorkoutConfigViewController *workoutConfigViewController = (WorkoutConfigViewController *)navController.childViewControllers[0];
        workoutConfigViewController.workout = self.workout;
        
        // Set the title of next controller to the workout's name
        workoutConfigViewController.title = self.workout.workoutName;
        
    } else if ([segue.identifier isEqualToString:@"GoToExercise"]) {

        WorkoutConfigViewController *workoutConfigViewController = (WorkoutConfigViewController *)navController.childViewControllers[0];
        
        ExerciseSetting *selectedExerciseSetting = self.exercisesForWorkout[indexPath.row];
        workoutConfigViewController.exerciseSetting = selectedExerciseSetting;
        
        // Set the title of next controller to the workout's name
        workoutConfigViewController.title = selectedExerciseSetting.baseExercise.exerciseName;
        
    } else if ([segue.identifier isEqualToString:@"StartWorkout"]) {
        
        RunWorkoutViewController *runWorkoutViewController = (RunWorkoutViewController *)navController.childViewControllers[0];
        runWorkoutViewController.workout = self.workout;
        runWorkoutViewController.exercisesForWorkout = self.exercisesForWorkout;
        
        // Set the title of next controller to the workout's name
        runWorkoutViewController.title = self.workout.workoutName;
    }
}

- (void)fetchAllExercisesForWorkout
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSArray *array = [Workout findByAttribute:@"workoutName" withValue:self.workoutName];
    self.workout = [array objectAtIndex:0];
    self.exercisesForWorkout = [[self.workout.exerciseGroup allObjects] mutableCopy];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    self.exercisesForWorkout = [[self.workout.exerciseGroup sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] mutableCopy];
    
    [self enableOrDisableStartButton];
}

/* Save data to the store */
- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

/* Only enable the START button when there is at least one exercise */
- (void)enableOrDisableStartButton
{
    double transparency = 0.6;
    bool isEnable = NO;
    
    if ([self.exercisesForWorkout count] > 0) {
        transparency = 1.0;
        isEnable = YES;
    }
    
    [self.startButton setUserInteractionEnabled:isEnable];
    [self.startButton setAlpha:transparency];
}

/* Long press cell to rearrange */
- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // White background
                    cell.backgroundColor = [UIColor whiteColor];
                } completion:nil];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {

                ExerciseSetting *sourceObject = [self.exercisesForWorkout objectAtIndex:sourceIndexPath.row];
                
                [self.exercisesForWorkout removeObjectAtIndex:sourceIndexPath.row];
                [self.exercisesForWorkout insertObject:sourceObject atIndex:indexPath.row];
                
                [self saveContext];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
                [self saveContext];

            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo the black-out effect we did.
                cell.backgroundColor = [UIColor whiteColor];
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            sourceIndexPath = nil;
            
            // Update the ExerciseSetting's index
            int i = 0;
            for (ExerciseSetting *exerciseSetting in self.exercisesForWorkout) {
                exerciseSetting.index = [NSNumber numberWithInt:i];
                i++;
            }
            
            [self saveContext];
            
            break;
        }
    }
}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end
