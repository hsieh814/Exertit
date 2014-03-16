//
//  Workout.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/11/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Exercise;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSString * minDuration;
@property (nonatomic, retain) NSString * workoutName;
@property (nonatomic, retain) NSString * secDuration;
@property (nonatomic, retain) NSSet *toExercise;

@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addToExerciseObject:(Exercise *)value;
- (void)removeToExerciseObject:(Exercise *)value;
- (void)addToExercise:(NSSet *)values;
- (void)removeToExercise:(NSSet *)values;

@end
