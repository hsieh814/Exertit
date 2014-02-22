//
//  Exercise.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2013-12-31.
//  Copyright (c) 2013 hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Exercise : NSObject

@property (nonatomic, copy) NSString *exerciseName;
@property (nonatomic, copy) NSString *exerciseSecDuration;
@property (nonatomic, copy) NSString *exerciseMinDuration;
@property (nonatomic, assign) NSInteger *exerciseSets;
@property (nonatomic, assign) NSInteger *exerciseReps;

@end
