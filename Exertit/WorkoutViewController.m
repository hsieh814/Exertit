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
#import "ExerciseCell.h"

@interface WorkoutViewController () <ExerciseCellDelegate>

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
    self.startButton.backgroundColor = [UIColor whiteColor];
    self.startButton.layer.borderColor = appleGreen.CGColor;
    self.startButton.layer.borderWidth = 2.0;
    self.startButton.layer.cornerRadius = 20.0f;
    self.startButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.startButton setTitleColor:appleGreen forState:UIControlStateNormal];
    
    // TableView customization
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = mediumBlue;
    
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
    
    // For swipe utility buttons
    cell.itemText = cell.exerciseName.text;
    cell.delegate = self;
    
    UIImage *img = [self checkExerciseCategory:[exerciseSetting.baseExercise.category integerValue]];
    cell.categoryImage.image = img;
    
    // Cell customization
    cell.layer.cornerRadius = 8.0f;
    cell.layer.masksToBounds = YES;
    
    // Check tag to prevent creating duplicate labels
    if ([cell viewWithTag:1 ] == nil) {
        // Labels for displaying exercise config settings
        self.rep = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 50, 20)];
        self.rep.textColor = grey;
        self.rep.font = [UIFont systemFontOfSize:12.0];
        self.rep.tag = 1;
        
        self.set = [[UILabel alloc] initWithFrame:CGRectMake(105, 40, 50, 20)];
        self.set.textColor = grey;
        self.set.font = [UIFont systemFontOfSize:12.0];
        self.set.tag = 2;
        
        self.weight = [[UILabel alloc] initWithFrame:CGRectMake(160, 40, 50, 20)];
        self.weight.textColor = grey;
        self.weight.font = [UIFont systemFontOfSize:12.0];
        self.weight.tag = 3;
        
        self.time = [[UILabel alloc] initWithFrame:CGRectMake(215, 40, 50, 20)];
        self.time.textColor = grey;
        self.time.font = [UIFont systemFontOfSize:12.0];
        self.time.tag = 4;
        
        [cell.myContentView addSubview:self.rep];
        [cell.myContentView addSubview:self.set];
        [cell.myContentView addSubview:self.weight];
        [cell.myContentView addSubview:self.time];
    }
    
    // Set/update the exerice settings labels
    NSInteger repInt = [exerciseSetting.reps integerValue];
    ((UILabel*)[cell viewWithTag:1]).text = [@"R: " stringByAppendingString:[NSString stringWithFormat: @"%02ld", (long)repInt]];

    NSInteger setInt = [exerciseSetting.sets integerValue];
    ((UILabel*)[cell viewWithTag:2]).text = [@"S: " stringByAppendingString:[NSString stringWithFormat: @"%02ld", (long)setInt]];
    
    ((UILabel*)[cell viewWithTag:3]).text = [@"W: " stringByAppendingString:[NSString stringWithFormat:@"%d", [exerciseSetting.weight intValue]]];

    int totalTimeInSeconds = [exerciseSetting.timeInterval intValue];
    int min = totalTimeInSeconds / 60;
    int sec = (totalTimeInSeconds % 60) / 5;
    NSString *s = [NSString stringWithFormat:@"T: %02zd:%02zd",  min, sec * 5];
    ((UILabel*)[cell viewWithTag:4]).text = s;
    
    return cell;
}

/* Called when a row is selected */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (self.indexPath != nil) {
        // Hide the utility buttons of the active cell when tapping on cell.
        [self.activeCell closeActivatedCells];
    }
}

// Begin scrolling -> hide active cell's utility buttons
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [self.activeCell closeActivatedCells];
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    UINavigationController *navController = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"AddExercise"]) {
        
        WorkoutConfigTableViewController *workoutConfigTableViewController = (WorkoutConfigTableViewController *)navController.childViewControllers[0];
        workoutConfigTableViewController.workout = self.workout;
        
        // Set the title of next controller to the workout's name
        workoutConfigTableViewController.title = self.workout.workoutName;
        
    } else if ([segue.identifier isEqualToString:@"GoToExercise"]) {

        WorkoutConfigTableViewController *workoutConfigTableViewController = (WorkoutConfigTableViewController *)navController.childViewControllers[0];
        
        ExerciseSetting *selectedExerciseSetting = self.exercisesForWorkout[self.indexPath.row];
        workoutConfigTableViewController.exerciseSetting = selectedExerciseSetting;
        
        // Set the title of next controller to the workout's name
        workoutConfigTableViewController.title = selectedExerciseSetting.baseExercise.exerciseName;
    } else if ([segue.identifier isEqualToString:@"StartWorkout"]) {
        
        RunWorkoutViewController *runWorkoutViewController = (RunWorkoutViewController *)navController.childViewControllers[0];
        runWorkoutViewController.workout = self.workout;
        runWorkoutViewController.exercisesForWorkout = self.exercisesForWorkout;
        
        // Set the title of next controller to the workout's name
        runWorkoutViewController.title = self.workout.workoutName;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Return NO if you do not want the specified item to be editable.
    return NO;
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

- (UIImage *)checkExerciseCategory:(NSInteger)tag
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    switch (tag) {
        case 0:
            return [UIImage imageNamed:@"category_default.png"];
            break;
        case 1:
            return [UIImage imageNamed:@"category_blue.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"category_red.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"category_yellow.png"];
            break;
        case 4:
            return [UIImage imageNamed:@"category_green.png"];
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark - SwipeableCellDelegate

- (void)editButtonActionForItemText:(NSString *)itemText {
    NSLog(@"Edit for %@", itemText);

    [self performSegueWithIdentifier:@"GoToExercise" sender:self];
}

- (void)deleteButtonActionForItemText:(NSString *)itemText {
    NSLog(@"Delete for %@", itemText);
    
    ExerciseSetting *exerciseSettingToRemove = self.exercisesForWorkout[self.indexPath.row];
    [exerciseSettingToRemove deleteEntity];
    [self saveContext];
    
    [self.exercisesForWorkout removeObjectAtIndex:self.indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self enableOrDisableStartButton];
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
    
    if (self.activeCell != nil) {
        // There an active cell (cells with utility buttons showing), need to close the active cell
        [self.activeCell closeActivatedCells];
    }
    
    self.indexPath = [self.tableView indexPathForCell:cell];
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
    
    self.indexPath = nil;
}

@end
