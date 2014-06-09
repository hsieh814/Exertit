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

@interface AllExercisesTableViewController () <ExerciseCellDelegate>

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
        
        SWRevealViewController *revealController = [self revealViewController];

        [revealController panGestureRecognizer];
        [revealController tapGestureRecognizer];
        
        // Slide out menu intialization
        self.sidebarButton.target = revealController;
        self.sidebarButton.action = @selector(revealToggle:);
    
        // Set the gesture
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        // Tableview customization
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = lightBlue;
        
        // Make tableview start lower
        UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
        self.tableView.contentInset = inset;
    }
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
    cell.exerciseName.textColor = themeNavBar4;
    
    cell.layer.cornerRadius = 8.0f;
    cell.layer.masksToBounds = YES;
    
    // For swipe utility buttons
    cell.itemText = cell.exerciseName.text;
    cell.delegate = self;
    
    return cell;
}

//// Change the background color of cells
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    cell.backgroundColor = cellBlue;
//}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
        // Hide the utility buttons of the active cell when tapping on cell.
        [self.activeCell closeActivatedCells];
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
        
        UINavigationController *navigationController = segue.destinationViewController;
        NewExerciseViewController *newExerciseViewController = (NewExerciseViewController *)navigationController.childViewControllers[0];
        newExerciseViewController.title = @"Edit Exercise";
        Exercise *selectedExercise = self.exerciseList[self.indexPath.row];
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

#pragma mark - SwipeableCellDelegate
- (void)editButtonActionForItemText:(NSString *)itemText {
    NSLog(@"AllExercises- Edit for %@", itemText);
    
    [self performSegueWithIdentifier:@"EditExercise" sender:self];
}

- (void)deleteButtonActionForItemText:(NSString *)itemText {
    NSLog(@"AllExericses- Delete for %@", itemText);
    
    // Remove Exercise object (the active cell currently showing the utility buttons)
    Exercise *exerciseToRemove = self.exerciseList[self.indexPath.row];
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
    
    [self.exerciseList removeObjectAtIndex:self.indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    self.activeCell = (ExerciseCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];

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
