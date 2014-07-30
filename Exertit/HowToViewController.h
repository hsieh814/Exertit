//
//  HowToViewController.h
//  Exertit
//
//  Created by Lena Hsieh on 2014-07-29.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowToViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) UIBarButtonItem *questionButton;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;

@end
