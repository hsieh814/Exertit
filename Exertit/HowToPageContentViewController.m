//
//  HowToPageContentViewController.m
//  Exertit
//
//  Created by Lena Hsieh on 2014-07-29.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "HowToPageContentViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

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
    
    if (IS_IPHONE_5) {
        self.tutorialImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 457)];
    } else {
        self.tutorialImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320, 369)];
    }
    
    // Need a special last page image if it is initial app launch
    if (self.pageIndex == 6 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunched"]) {
        // INITIAL LAUNCH
        // Add "Got it" button
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(81, 370, 140, 50)];
        [button setTitle:@"Got It!" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [button setTitleColor:themeNavBar forState:UIControlStateNormal];
        button.layer.borderColor = themeNavBar.CGColor;
        button.layer.borderWidth = 2.0;
        button.layer.cornerRadius = 20.0f;
        [button addTarget:self action:@selector(dismissInitialHowToGuide:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:button];
        [self.view bringSubviewToFront:button]; // Make sure button is on top of the image views
        
        // Set the last image to be the initial launch one
        self.tutorialImage.image = [UIImage imageNamed:@"guide_iphone5_7_launch.png"];
    } else {
        // NORMAL
        self.tutorialImage.image = [UIImage imageNamed:self.imageFile];
    }
    
    [self.view addSubview:self.tutorialImage];
}

- (void)dismissInitialHowToGuide:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Remove the How To Guide view
    [self.view removeFromSuperview];
    
    // Set the root controller back to original
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    SWRevealViewController *split = [storyboard instantiateViewControllerWithIdentifier:@"root"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = split;
    
    // Set the UserDefaults initial launch to YES
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunched"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
