//
//  IntervalTimerViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/5/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "IntervalTimerViewController.h"
#import "SWRevealViewController.h"

@interface IntervalTimerViewController ()

@end

@implementation IntervalTimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Slide out menu intialization
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
