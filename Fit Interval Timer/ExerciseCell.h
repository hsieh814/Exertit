//
//  ExerciseCell.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/17/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExerciseCellDelegate <NSObject>
- (void)editButtonActionForItemText:(NSString *)itemText;
- (void)deleteButtonActionForItemText:(NSString *)itemText;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;
@end

// Subclassing UITableViewCell to change width of cell
@interface ExerciseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIView *myContentView;
@property (weak, nonatomic) IBOutlet UILabel *exerciseName;

// For setting the test label, which is in the cell's content view
@property (nonatomic, strong) NSString *itemText;
@property (nonatomic, weak) id <ExerciseCellDelegate> delegate;

- (void)openCell;

@end
