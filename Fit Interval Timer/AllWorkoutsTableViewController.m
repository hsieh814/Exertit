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

@interface AllWorkoutsTableViewController () <WorkoutCellDelegate>

@end

@implementation AllWorkoutsTableViewController

bool isScrolling = NO;

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

    // Slide out menu intialization
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // TableView customization
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = lightBlue;
    
    // Make tableview start lower
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
}

// called everytime we enter the view
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Fetch all workouts
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
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    WorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell"];
    Workout *workout = [self.workoutList objectAtIndex:indexPath.row];
    cell.workoutName.text = workout.workoutName;
    cell.workoutName.textColor = themeNavBar4;

    cell.layer.cornerRadius = 8.0f;
    cell.layer.masksToBounds = YES;
    
    cell.itemText = cell.workoutName.text;
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    isScrolling = YES;
    [self.activeCell closeActivatedCells];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    isScrolling = NO;
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if ([segue.identifier isEqualToString:@"AddWorkout"]) {

        
    } else if ([segue.identifier isEqualToString:@"goToWorkout"]) {
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

#pragma mark - SwipeableCellDelegate
- (void)editButtonActionForItemText:(NSString *)itemText {
    NSLog(@"Edit for %@", itemText);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rename Workout"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Rename", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *alertTextField = [alert textFieldAtIndex:0];
    alertTextField.text = itemText;
    alertTextField.clearButtonMode = YES;
    alertTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [alertTextField becomeFirstResponder];
    [alert addSubview:alertTextField];
    [alert show];
}

- (void)deleteButtonActionForItemText:(NSString *)itemText {
    NSLog(@"Delete for %@", itemText);
    
    // Remove the Workout object
    Workout *workoutToRemove = self.workoutList[self.indexPath.row];
    [workoutToRemove deleteEntity];
    
    // Need to also remove the associated ExerciseSetting objects
    NSArray *exerciseSettingArray = [workoutToRemove.exerciseGroup allObjects];
    for (int i = 0; i < [exerciseSettingArray count]; i++) {
        ExerciseSetting *exerciseSetting = exerciseSettingArray[i];
        [exerciseSetting deleteEntity];
    }
    
    [self saveContext];
    
    [self.workoutList removeObjectAtIndex:self.indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if (buttonIndex == alert.cancelButtonIndex)
    {
        NSLog(@"CANCEL alert view");
        [self.activeCell closeActivatedCells];
    }
    else
    {
        NSLog(@"RENAME alert view");
        Workout *editWorkout = self.workoutList[self.indexPath.row];
        editWorkout.workoutName = [[alert textFieldAtIndex:0]text];
        
        // Reload data
        [self viewDidAppear:YES];
    }
}

//4
- (void)closeModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Called when showing a cell's utility buttons
- (void)cellDidOpen:(UITableViewCell *)cell
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    self.indexPath = [self.tableView indexPathForCell:cell];
    
    if (self.activeCell != nil) {
        // There is no active cell (no cells with utility buttons showing)
        [self.activeCell closeActivatedCells];
    }
    
    self.activeCell = (WorkoutCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
    
}

// Called when hiding a cell's utility buttons
- (void)cellDidClose:(UITableViewCell *)cell
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Avoid setting activeCell to nil when closing a cell that does isn't showing its utility buttons.
    if (self.activeCell == cell) {
        self.activeCell = nil;
    }
}

@end
