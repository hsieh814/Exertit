//
//  AddExerciseViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-03-22.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"
#import "NewExerciseViewController.h"

@class AddExerciseViewController;

@protocol AddExerciseViewControllerDelegate <NSObject>
- (void)addExerciseViewControllerDidCancel:(AddExerciseViewController *)controller;
- (void)addExerciseViewController:(AddExerciseViewController *)controller didAddExercise:(Exercise *)addExercise;
@end

@interface AddExerciseViewController : UITableViewController <NewExerciseViewControllerDelegate>

@property (nonatomic, weak) id <AddExerciseViewControllerDelegate> delegate;

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *fetchedRecordArray;

@end
