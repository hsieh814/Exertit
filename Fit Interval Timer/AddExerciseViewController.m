//
//  AddExerciseViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-03-22.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "AddExerciseViewController.h"
#import "timerAppDelegate.h"
#import "ExerciseCell.h"
#import "Exercise.h"
#import "NewExerciseViewController.h"

@interface AddExerciseViewController ()

@end

timerAppDelegate *appDelegate;

@implementation AddExerciseViewController

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

    // Core data
//    appDelegate = [UIApplication sharedApplication].delegate;
    
    // Fetch the exercises and reload the table
//    self.fetchedRecordArray = [appDelegate getAllExercises];
    
    // Initialize the NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Set the entity to be queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exercise" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    // Questy managedObjectContext
    self.fetchedRecordArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    return [self.fetchedRecordArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    ExerciseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell"];
    Exercise *exercise = [self.fetchedRecordArray objectAtIndex:indexPath.row];
    NSLog(@"%@", self.fetchedRecordArray[indexPath.row]);
    cell.exerciseName.text = exercise.exerciseName;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//- (IBAction)AddExercise:(id)sender {
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    Exercise *exercise = (Exercise *)[NSEntityDescription insertNewObjectForEntityForName:@"Exercise" inManagedObjectContext:context];
//    exercise.exerciseName = @"testing";
//    exercise.exerciseMinDuration = @"1";
//    exercise.exerciseSecDuration = @"30";
//    exercise.exerciseReps = @"15";
//    exercise.exerciseSets = @"3";
//}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([segue.identifier isEqualToString:@"AddExercise"]) {
        
    }
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
    
    // Re-fetch the exercise list
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Set the entity to be queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Exercise" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    // Questy managedObjectContext
    self.fetchedRecordArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
