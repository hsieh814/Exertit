//
//  NewExerciseTableViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-06-14.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultCell.h"
#import "Exercise.h"

@interface NewExerciseTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet DefaultCell *defaultCell;
@property (nonatomic) NSMutableArray *exerciseList;
@property (nonatomic, strong) Exercise *exercise;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
