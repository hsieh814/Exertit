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
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Return the number of rows in the section.
    return self.exercisesForWorkout.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    ExerciseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell" forIndexPath:indexPath];
    ExerciseSetting *exerciseSetting = [self.exercisesForWorkout objectAtIndex:indexPath.row];
    cell.exerciseName.text = exerciseSetting.name;
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        Workout *workoutToRemove = self.workoutList[indexPath.row];
//        [workoutToRemove deleteEntity];
//        [self saveContext];
        
//        [self.exercisesForWorkout removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if ([segue.identifier isEqualToString:@"AddExercise"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        WorkoutConfigViewController *workoutConfigViewController = (WorkoutConfigViewController *)navigationController.childViewControllers[0];
        
        workoutConfigViewController.workout = self.workout;
        NSLog(@"----------\n %@", self.workout);
        
        // Set the title of next controller to the workout's name
        workoutConfigViewController.title = self.workout.workoutName;
        
        // Set the WorkoutConfigViewController delegate
//        workoutConfigViewController.delegate = self;
    }
}

- (void)fetchAllExercisesForWorkout
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

//    NSArray *workouts = [[Workout findAllSortedBy:@"workoutName" ascending:NO] mutableCopy];
//    if (workouts.count == 1) {
//        NSLog(@"fetchAllExercisesForWorkout - found workout");
//        Workout *workout = workouts[0];
//        self.exercisesForWorkout = [[workout.exerciseGroup allObjects] mutableCopy];
//    } else {
//        NSLog(@"fetchAllExercisesForWorkout - more than one workout");
//    }
    
    NSLog(@"--> \n %@", self.workout);
    self.exercisesForWorkout = [[self.workout.exerciseGroup allObjects] mutableCopy];
}

/* Save data to the store */
- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

@end
