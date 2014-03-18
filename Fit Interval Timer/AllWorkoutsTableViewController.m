//
//  AllWorkoutsTableViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-02.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "AllWorkoutsTableViewController.h"
#import "SWRevealViewController.h"
#import "WorkoutCell.h"
#import "Workout.h"
#import "Exercise.h"
#import "timerAppDelegate.h"

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
    
    // Initialize the workout array
//    self.workoutList = [[NSMutableArray alloc] init];
    
/************************************************************************************/
    appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Fetch the workouts and reload the table
    self.fetchedRecordArray = [appDelegate getAllWorkouts];
    [self.tableView reloadData];
/************************************************************************************/
    
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
    return [self.fetchedRecordArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    WorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell"];
    Workout *workout = [self.fetchedRecordArray objectAtIndex:indexPath.row];
    cell.workoutNameLabel.text = workout.workoutName;
    cell.workoutDurationLabel.text = [NSString stringWithFormat:@"%@:%@", workout.minDuration, workout.secDuration];

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    // Swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.managedObjectContext deleteObject:[self.fetchedRecordArray objectAtIndex:[indexPath row]]];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        self.fetchedRecordArray = [appDelegate getAllWorkouts];
        [tableView reloadData];
    }
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if ([segue.identifier isEqualToString:@"AddWorkout"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        NewWorkoutViewController *newWorkoutViewController = [navigationController viewControllers][0];
        newWorkoutViewController.managedObjectContext = self.managedObjectContext;
        newWorkoutViewController.delegate = self;
    }
}

#pragma mark - NewWorkoutViewControllerDelegate

- (void)newWorkoutViewControllerDidCancel:(NewWorkoutViewController *)controller
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)newWorkoutViewControllerDidSave:(NewWorkoutViewController *)controller
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)newWorkoutViewController:(NewWorkoutViewController *)controller;
{
    NSLog(@"%@", NSStringFromSelector(_cmd));

    // Re-fetch the workout list
    self.fetchedRecordArray = [appDelegate getAllWorkouts];

    // Display the new workout in the table
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.fetchedRecordArray count] - 1 inSection:0];
//	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView reloadData];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
