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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];

    if (indexPath.section == 0) {
        // Favorite list
        
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
