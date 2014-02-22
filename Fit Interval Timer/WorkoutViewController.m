//
//  WorkoutViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2/15/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "WorkoutViewController.h"

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddExercise"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        WorkoutConfigViewController *workoutConfigViewController = [navigationController viewControllers][0];
        workoutConfigViewController.delegate = self;
    }
}

- (void)workoutConfigViewControllerDidCancel:(WorkoutConfigViewController *)controller
{
    NSLog(@"Hit Cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)workoutConfigViewController:(WorkoutConfigViewController *)controller didAddExercise:(Exercise *)exercise
{
    // Add workout to the workout array
//    [self.workoutList addObject:workout];
    
    // Display the new workout in the table
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.workoutList count] - 1 inSection:0];
//	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    NSLog(@"Hit done button");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
