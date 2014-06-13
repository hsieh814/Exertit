//
//  workoutCell.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-01.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WorkoutCellDelegate <NSObject>
- (void)editButtonActionForItemText:(NSString *)itemText;
- (void)deleteButtonActionForItemText:(NSString *)itemText;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end

@interface WorkoutCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIView *myContentView;
@property (weak, nonatomic) IBOutlet UILabel *workoutName;

// For setting the test label, which is in the cell's content view
@property (nonatomic, strong) NSString *itemText;
@property (nonatomic, weak) id <WorkoutCellDelegate> delegate;

- (void)openCell;
- (void)closeActivatedCells;

@end
