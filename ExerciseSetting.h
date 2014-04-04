//
//  ExerciseSetting.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-02.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface ExerciseSetting : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sets;
@property (nonatomic, retain) NSString * min;
@property (nonatomic, retain) NSString * reps;
@property (nonatomic, retain) NSString * sec;
@property (nonatomic, retain) Workout *workoutGroup;

@end
