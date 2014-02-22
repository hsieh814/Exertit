//
//  workoutCell.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-01.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *workoutNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workoutDurationLabel;

@end
