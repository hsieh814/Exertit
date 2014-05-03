//
//  menuViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-01.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "MenuViewController.h"
#import "Workout.h"
#import "Exercise.h"
#import "MenuCell.h"
#import "SWRevealViewController.h"
#import "SettingsTableViewController.h"
#import "timerAppDelegate.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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

/*  1- Click a cell on the slide out menu
    2- Calls didSelectRowAtIndexPath to determine the segue to perform
    3- Calls prepareForSegue to set the new Front view
 */

// Determine which segue to perform based on the cell selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"---- didSelectRowAtIndexPath ----");

    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"AllWorkouts" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"AllExercises" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"Timer" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"IntervalTimer" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"Settings" sender:self];
            break;
    }
}

// Set the new Front view for the slide-out menu
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    NSLog(@"---- prepareForSegue -----");

    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
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
    if (section == 0) {
        // List of favorite workouts
        return [self.favoriteWorkoutList count];
    } else {
        // Default menu
        return 5;
    }
}

// Titles for the table sections
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
//        return @"Favorites";
        return @"";
    } else {
        return @" ";
    }
}

// Customize header colors
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Set the text color of our header/footer text.
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Set the background color of our header/footer.
//    header.contentView.backgroundColor = [UIColor colorWithRed:64/255.0f green:136/255.0f blue:255/255.0f alpha:1.0f];
    
    // You can also do this to set the background color of our header/footer,
    //    but the gradients/other effects will be retained.
    // view.tintColor = [UIColor blackColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];

    if (indexPath.section == 0) {
        // Favorite list
        Workout *workout = [self.favoriteWorkoutList objectAtIndex:indexPath.row];
        cell.menuCellName.text = workout.workoutName;
        cell.menuCellImage.image = [UIImage imageNamed:@"mandriva-512.png"];
        
    } else if (indexPath.section == 1) {
        // Default menu list
        
        switch (indexPath.row) {
            case 0:
                cell.menuCellName.text = @"All Workouts";
                cell.menuCellImage.image = [UIImage imageNamed:@"google_earth-512.png"];
                break;
            case 1:
                cell.menuCellName.text = @"All Exercises";
                cell.menuCellImage.image = [UIImage imageNamed:@"coderwall-512.png"];
                break;
            case 2:
                cell.menuCellName.text = @"Timer";
                cell.menuCellImage.image = [UIImage imageNamed:@"timer-512.png"];
                break;
            case 3:
                cell.menuCellName.text = @"Interval Trainer";
                cell.menuCellImage.image = [UIImage imageNamed:@"cloudflare-512.png"];
                break;
            case 4:
                cell.menuCellName.text = @"Settings";
                cell.menuCellImage.image = [UIImage imageNamed:@"reddit-512.png"];
                break;
        }
        
    }
    
    return cell;
}


@end
