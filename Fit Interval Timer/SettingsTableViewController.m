//
//  SettingsTableViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/2/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SWRevealViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (IBAction)changeTheme:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    switch (self.selectTheme.selectedSegmentIndex) {
        case 0:
            self.navigationController.navigationBar.barTintColor = themeNavBar;
            break;
        case 1:
            self.navigationController.navigationBar.barTintColor = themeNavBar2;
            break;
        case 2:
            self.navigationController.navigationBar.barTintColor = themeNavBar3;
            break;
        case 3:
            self.navigationController.navigationBar.barTintColor = themeNavBar4;
            break;
        case 4:
            self.navigationController.navigationBar.barTintColor = themeNavBar5;
            break;
        case 5:
            self.navigationController.navigationBar.barTintColor = themeNavBar6;
            break;
        default:
            break;
    }
}
@end
