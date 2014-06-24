//
//  SettingsTableViewController.h
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/2/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultCell.h"

@interface SettingsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet DefaultCell *SettingCell;

@end
