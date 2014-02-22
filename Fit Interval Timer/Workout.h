//
//  Workout.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2013-12-31.
//  Copyright (c) 2013 hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Workout : NSObject

@property (nonatomic, copy) NSString *workoutName;
@property (nonatomic, copy) NSString *minDuration;
@property (nonatomic, copy) NSString *secDuration;
@property (nonatomic, copy) NSMutableArray *exerciseList;

// Call when Workout object is initialized
-(id)init;

@end
