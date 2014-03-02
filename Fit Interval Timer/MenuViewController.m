//
//  menuViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-01.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "MenuViewController.h"
#import "Workout.h"
#import "MenuCell.h"

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
    
    self.favoriteWorkoutList = [[NSMutableArray alloc] init];
    
    /**********************************************************/
    Workout *wk = [[Workout alloc]init];
    wk.workoutName = @"name";
    [self.favoriteWorkoutList addObject:wk];
    /**********************************************************/

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
        return @"Favorites";
    } else {
        return @" ";
    }
}

// Customize header colors
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Set the text color of our header/footer text.
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Set the background color of our header/footer.
    header.contentView.backgroundColor = [UIColor colorWithRed:64/255.0f green:136/255.0f blue:255/255.0f alpha:1.0f];
    
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
                cell.menuCellName.text = @"Interval Training";
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
