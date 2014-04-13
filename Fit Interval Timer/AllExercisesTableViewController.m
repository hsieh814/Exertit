//
//  AllExercisesTableViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/5/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "AllExercisesTableViewController.h"
#import "SWRevealViewController.h"
#import "Exercise.h"
#import "ExerciseCell.h"
#import "timerAppDelegate.h"
#import "WorkoutConfigViewController.h"

@interface AllExercisesTableViewController ()

@end

@implementation AllExercisesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

// called the first time we enter the view
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if (_sidebarButton != nil) {
        // Slide out menu intialization
        _sidebarButton.target = self.revealViewController;
        _sidebarButton.action = @selector(revealToggle:);
    
        // Set the gesture
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Long press gesture for moving table cells
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];
 }

// called everytime we enter the view
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Fetch all exercises
    [self fetchAllExercises];
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.exerciseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    ExerciseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell"];
    Exercise *exercise = self.exerciseList[indexPath.row];
    cell.exerciseName.text = exercise.exerciseName;
    
    NSLog(@"%@", exercise);
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Remove Exercise object
        Exercise *exerciseToRemove = self.exerciseList[indexPath.row];
        [exerciseToRemove deleteEntity];
        
        // Remove the associated ExerciseSetting objects
        // Change NSSet to NSArray to get object at index
        NSArray *exerciseSettingArray = [exerciseToRemove.highLevelExercise allObjects];

        if (sizeof(exerciseSettingArray) > 0) {
            for (int i = 0; i < [exerciseSettingArray count]; i++) {
                ExerciseSetting *exerciseSetting = exerciseSettingArray[i];
                [exerciseSetting deleteEntity];
            }
        }
        
        [self saveContext];

        [self.exerciseList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/* Called when a row is selected */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([self.presentingViewController isKindOfClass:[SWRevealViewController class]]) {
        // Previous view controller is the WorkoutConfigViewController. Need to pass the selected exercise back.
        Exercise *selectedExercise = self.exerciseList[indexPath.row];
        [self.delegate allExercisesViewControllerDidSelectWorkout:self didSelectExercise:selectedExercise];
    } else {
        NSLog(@"here");
//        [self performSegueWithIdentifier:@"EditExercise" sender:self];
    }

}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([segue.identifier isEqualToString:@"AddExercise"]) {
        NSLog(@"AddExercise segue");
        
    } else if ([segue.identifier isEqualToString:@"EditExercise"]) {
        NSLog(@"EditExercise segue");
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        UINavigationController *navigationController = segue.destinationViewController;
        NewExerciseViewController *newExerciseViewController = (NewExerciseViewController *)navigationController.childViewControllers[0];
        newExerciseViewController.title = @"Edit Exercise";
        Exercise *selectedExercise = self.exerciseList[indexPath.row];
        newExerciseViewController.exercise = selectedExercise;
    }
}

/* Fetch all exercises using MagicalRecords */
- (void)fetchAllExercises
{
    self.exerciseList = [[Exercise findAllSortedBy:@"exerciseName" ascending:YES] mutableCopy];
}

/* Save data to the store */
- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

#pragma mark - NewExerciseViewControllerDelegate

- (void)newExerciseViewControllerDidCancel:(NewExerciseViewController *)controller
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)newExerciseViewControllerDidSave:(NewExerciseViewController *)controller
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)newExerciseViewController:(NewExerciseViewController *)controller;
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

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
                
                // ... update data source.
                [self.exerciseList exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
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
