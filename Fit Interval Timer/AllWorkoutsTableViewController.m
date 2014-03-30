//
//  AllWorkoutsTableViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-02.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "AllWorkoutsTableViewController.h"
#import "SWRevealViewController.h"
#import "Workout.h"
#import "WorkoutCell.h"
#import "Exercise.h"
#import "timerAppDelegate.h"
#import "WorkoutViewController.h"

@interface AllWorkoutsTableViewController ()

@end

timerAppDelegate *appDelegate;

@implementation AllWorkoutsTableViewController

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

    NSLog(@"%@", NSStringFromSelector(_cmd));

    // Slide out menu intialization
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Fetch all workouts
    [self fetchAllWorkouts];
    
    // Reload table
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Fetch all exercises
    [self fetchAllWorkouts];
    
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
    return self.workoutList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    WorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell"];
    Workout *workout = [self.workoutList objectAtIndex:indexPath.row];
    cell.workoutNameLabel.text = workout.workoutName;
    cell.workoutDurationLabel.text = [NSString stringWithFormat:@"%@:%@", workout.minDuration, workout.secDuration];

    NSLog(@"%@", workout);

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Workout *workoutToRemove = self.workoutList[indexPath.row];
        [workoutToRemove deleteEntity];
        [self saveContext];
        
        [self.workoutList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if ([segue.identifier isEqualToString:@"AddWorkout"]) {

        
    }else if ([segue.identifier isEqualToString:@"goToWorkout"]) {

    }
}

/* Fetch all workouts using MagicalRecords */
- (void)fetchAllWorkouts
{
    self.workoutList = [[Workout findAllSortedBy:@"workoutName" ascending:YES] mutableCopy];
}

/* Save data to the store */
- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

#pragma mark - NewWorkoutViewControllerDelegate

//- (void)newWorkoutViewControllerDidCancel:(NewWorkoutViewController *)controller
//{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)newWorkoutViewControllerDidSave:(NewWorkoutViewController *)controller
//{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
//
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)newWorkoutViewController:(NewWorkoutViewController *)controller;
//{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
//
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

@end
