//
//  AllWorkoutsTableViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-02.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewWorkoutViewController.h"

@interface AllWorkoutsTableViewController : UITableViewController <NewWorkoutViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (nonatomic, strong) NSMutableArray *workoutList;

@end
