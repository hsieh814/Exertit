//
//  AllExercisesTableViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/5/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewExerciseViewController.h"
#import "timerAppDelegate.h"

@interface AllExercisesTableViewController : UITableViewController <NewExerciseViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic) NSMutableArray *exerciseList;

@end
