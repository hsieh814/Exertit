//
//  Exercise.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/11/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSString * exerciseName;
@property (nonatomic, retain) NSString * exerciseSets;
@property (nonatomic, retain) NSString * exerciseMinDuration;
@property (nonatomic, retain) NSString * exerciseSecDuration;
@property (nonatomic, retain) NSString * exerciseReps;
@property (nonatomic, retain) Workout *toWorkout;

@end
