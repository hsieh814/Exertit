//
//  HowToPageContentViewController.m
//  Exertit
//
//  Created by Lena Hsieh on 2014-07-29.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "HowToPageContentViewController.h"

@interface HowToPageContentViewController ()

@end

@implementation HowToPageContentViewController

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
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    self.tutorialImage.image = [UIImage imageNamed:self.imageFile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
