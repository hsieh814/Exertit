//
//  ExerciseSetting.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-06.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise, Workout;

@interface ExerciseSetting : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * sets;
@property (nonatomic, retain) NSNumber * timeInterval;
@property (nonatomic, retain) Exercise *baseExercise;
@property (nonatomic, retain) Workout *workoutGroup;

@end
