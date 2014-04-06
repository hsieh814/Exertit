//
//  Workout.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-06.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExerciseSetting;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSString * minDuration;
@property (nonatomic, retain) NSString * secDuration;
@property (nonatomic, retain) NSString * workoutName;
@property (nonatomic, retain) NSSet *exerciseGroup;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addExerciseGroupObject:(ExerciseSetting *)value;
- (void)removeExerciseGroupObject:(ExerciseSetting *)value;
- (void)addExerciseGroup:(NSSet *)values;
- (void)removeExerciseGroup:(NSSet *)values;

@end
