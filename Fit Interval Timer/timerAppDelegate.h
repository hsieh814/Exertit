//
//  timerAppDelegate.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2013-12-30.
//  Copyright (c) 2013 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Core data
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;

// Fetch data methods
-(NSArray *)getAllWorkouts;

@end
