//
//  menuViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-01.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarViewController : UITableViewController

@property (nonatomic, strong) NSArray *favoriteWorkoutList;


@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@end
