//
//  Exercise.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-03-24.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSString * exerciseMinDuration;
@property (nonatomic, retain) NSString * exerciseName;
@property (nonatomic, retain) NSString * exerciseReps;
@property (nonatomic, retain) NSString * exerciseSecDuration;
@property (nonatomic, retain) NSString * exerciseSets;

@end
