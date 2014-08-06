//
//  HowToViewController.m
//  Exertit
//
//  Created by Lena Hsieh on 2014-07-29.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "HowToViewController.h"
#import "HowToPageContentViewController.h"
#import "SWRevealViewController.h"

@interface HowToViewController ()

@end

@implementation HowToViewController

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

    // Slide out menu customization
    _sidebarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"slide_menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = _sidebarButton;
    
    // View customization
    self.title = @"How-To Guide";
    
    self.pageImages = @[@"guide_iphone5_1", @"guide_iphone5_2", @"guide_iphone5_3", @"guide_iphone5_4", @"guide_iphone5_5", @"guide_iphone5_6", @"guide_iphone5_7"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    HowToPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    NSLog(@"%f, %f, %f", self.view.frame.size.height, navBarHeight, statusBarHeight);
    self.pageViewController.view.frame = CGRectMake(0, 0/*navBarHeight + statusBarHeight*/, self.view.frame.size.width, self.view.frame.size.height - 10);

    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (HowToPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    HowToPageContentViewController *howToPageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HowToPageContentViewController"];
    howToPageContentViewController.pageIndex = index;
    howToPageContentViewController.imageFile = self.pageImages[index];
    
    return howToPageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    NSUInteger index = ((HowToPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    NSUInteger index = ((HowToPageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageImages count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    return 0;
}

@end
