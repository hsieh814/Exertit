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
#import "AppDelegate.h"
#import "GAIDictionaryBuilder.h"

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
    
    self.tableView.backgroundColor = darkBlue;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = themeNavBar;

    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Google Analytics
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"MenuView"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

/*  1- Click a cell on the slide out menu
    2- Calls didSelectRowAtIndexPath to determine the segue to perform
    3- Calls prepareForSegue to set the new Front view
 */

// Determine which segue to perform based on the cell selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            [self performSegueWithIdentifier:@"AllWorkouts" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"AllExercises" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"Timer" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"IntervalTimer" sender:self];
            break;
        case 5:
            [self performSegueWithIdentifier:@"Settings" sender:self];
            break;
        case 6:
            [self performSegueWithIdentifier:@"HowTo" sender:self];
            break;
        case 7:
            [self performSegueWithIdentifier:@"About" sender:self];
            break;
    }
}

// Set the new Front view for the slide-out menu
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

// Set the row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_5) {
        return 60;
    } else {
        return 56;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    cell.menuCellName.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];

    // Default menu list
    switch (indexPath.row) {
        case 0:
        {
            cell.menuCellName.text = @"xert It";
            cell.menuCellImage.image = [UIImage imageNamed:@"exertit_hexagon.png"];
            
            // Cannot select cell
            [cell setUserInteractionEnabled:NO];
            
            break;
        }
        case 1:
            cell.menuCellName.text = @"All Workouts";
            cell.menuCellImage.image = [UIImage imageNamed:@"workouts_120.png"];
            break;
        case 2:
            cell.menuCellName.text = @"All Exercises";
            cell.menuCellImage.image = [UIImage imageNamed:@"exercises_120.png"];
            break;
        case 3:
            cell.menuCellName.text = @"Timer";
            cell.menuCellImage.image = [UIImage imageNamed:@"timer_120.png"];
            break;
        case 4:
            cell.menuCellName.text = @"Interval Trainer";
            cell.menuCellImage.image = [UIImage imageNamed:@"interval_trainer_120.png"];
            break;
        case 5:
            cell.menuCellName.text = @"Settings";
            cell.menuCellImage.image = [UIImage imageNamed:@"settings_120.png"];
            break;
        case 6:
            cell.menuCellName.text = @"How-To Guide";
            cell.menuCellImage.image = [UIImage imageNamed:@"howtoguide_120.png"];
            break;
        case 7:
            cell.menuCellName.text = @"About";
            cell.menuCellImage.image = [UIImage imageNamed:@"about_120.png"];
            break;
    }
    
    cell.backgroundColor = darkBlue;
    cell.menuCellName.textColor = [UIColor whiteColor];
    
    return cell;
}

@end
