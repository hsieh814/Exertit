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
#import "WorkoutViewController.h"

@interface AllWorkoutsTableViewController ()

@end

@implementation AllWorkoutsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

// called the first time we enter the view
- (void)viewDidLoad
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    NSLog(@"%@", NSStringFromSelector(_cmd));

    // Slide out menu intialization
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

// called everytime we enter the view
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
        
        // Remove the Workout object
        Workout *workoutToRemove = self.workoutList[indexPath.row];
        [workoutToRemove deleteEntity];
        
        // Need to also remove the associated ExerciseSetting objects
        NSArray *exerciseSettingArray = [workoutToRemove.exerciseGroup allObjects];
        for (int i = 0; i < [exerciseSettingArray count]; i++) {
            ExerciseSetting *exerciseSetting = exerciseSettingArray[i];
            [exerciseSetting deleteEntity];
        }
        
        [self saveContext];
        
        [self.workoutList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if ([segue.identifier isEqualToString:@"AddWorkout"]) {

        
    }else if ([segue.identifier isEqualToString:@"goToWorkout"]) {
        // index of the selected row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WorkoutViewController *workoutViewController = segue.destinationViewController;
        
        Workout *selectedWorkout = self.workoutList[indexPath.row];
        workoutViewController.workoutName = selectedWorkout.workoutName;
        
        // Set the title of next controller to the workout's name
        workoutViewController.title = selectedWorkout.workoutName;
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

@end
