//
//  workoutsTableViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-02.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutDetailsViewController.h"

@interface workoutsTableViewController : UITableViewController <WorkoutDetailsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (nonatomic, strong) NSMutableArray *workoutList;

@end
