//
//  Workout.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-03-24.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Workout : NSManagedObject

@property (nonatomic, retain) NSString * minDuration;
@property (nonatomic, retain) NSString * secDuration;
@property (nonatomic, retain) NSString * workoutName;

@end
