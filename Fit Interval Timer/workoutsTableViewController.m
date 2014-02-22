//
//  workoutsTableViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-02.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "workoutsTableViewController.h"
#import "SWRevealViewController.h"
#import "WorkoutCell.h"
#import "Workout.h"

@interface workoutsTableViewController ()

@end

@implementation workoutsTableViewController

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

    // Slide out menu intialization
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Initialize the workout array
    self.workoutList = [[NSMutableArray alloc] init];

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
    return [self.workoutList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell"];
    Workout *workout = [self.workoutList objectAtIndex:indexPath.row];
    cell.workoutNameLabel.text = workout.workoutName;
    cell.workoutDurationLabel.text = [NSString stringWithFormat:@"%@:%@", workout.minDuration, workout.secDuration];

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Swipe to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.workoutList removeObjectAtIndex:[indexPath row]];
        [tableView reloadData];
    }
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddWorkout"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        WorkoutDetailsViewController *workoutDetailsViewController = [navigationController viewControllers][0];
        workoutDetailsViewController.delegate = self;
    }
}

#pragma mark - PlayerDetailsViewControllerDelegate

- (void)workoutDetailsViewControllerDidCancel:(WorkoutDetailsViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)workoutDetailsViewControllerDidSave:(WorkoutDetailsViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)workoutDetailsViewController:(WorkoutDetailsViewController *)controller didAddWorkout:(Workout *)workout;
{
    // Add workout to the workout array
    [self.workoutList addObject:workout];

    // Display the new workout in the table
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.workoutList count] - 1 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
