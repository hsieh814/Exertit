//
//  Exercise.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-06.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ExerciseSetting;

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSString * exerciseName;
@property (nonatomic, retain) NSSet *highLevelExercise;
@end

@interface Exercise (CoreDataGeneratedAccessors)

- (void)addHighLevelExerciseObject:(ExerciseSetting *)value;
- (void)removeHighLevelExerciseObject:(ExerciseSetting *)value;
- (void)addHighLevelExercise:(NSSet *)values;
- (void)removeHighLevelExercise:(NSSet *)values;

@end
