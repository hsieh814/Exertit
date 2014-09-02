//
//  SettingsTableViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/2/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SWRevealViewController.h"
#import "DefaultCell.h"
#import "DefaultCellTitleUnderline.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

NSString *unitSelected;
UILabel *unitLabel;
bool soundOn, vibrateOn;

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

    // Slide out menu customization
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    // Set the gesture
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
    
    // TableView customization
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = mediumBlue;

    // Get the saved user settings
    [self getUserDefaults];

}

// called everytime we enter the view
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [self setUserDefaults:self];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell" forIndexPath:indexPath];
    
    // Change spacing between DefaultCell
    [cell setDefaultHeightBorder:6];
    [cell setDefaultWidthBorder:10];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 260, 20)];
    [title setFont:[UIFont boldSystemFontOfSize:16.0]];
    title.textColor = themeNavBar;
    
    DefaultCellTitleUnderline *titleUnderline = [[DefaultCellTitleUnderline alloc]initWithFrame:CGRectMake(20, 43, 260, 1)];
    
    switch (indexPath.row) {
        case 0:
        {
            title.text = @"Sound";

            UILabel *alertInfo = [[UILabel alloc]initWithFrame:CGRectMake(40, 40, 250, 50)];
            alertInfo.text = @"Enable/disable alerts and vibrations when running interval trainer";
            alertInfo.font = [UIFont systemFontOfSize:14.0];
            alertInfo.textColor = [UIColor grayColor];
            alertInfo.numberOfLines = 2;
            
            UILabel *soundLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 90, 200, 40)];
            soundLabel.text = @"Alert";
            soundLabel.font = [UIFont systemFontOfSize:18.0];
            UISwitch *soundSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(210, 95, 50, 40)];
            [soundSwitch addTarget:self action:@selector(toggleSound:) forControlEvents:UIControlEventValueChanged];
            [soundSwitch setOn:soundOn];
            
            NSLog(@"%f, %f", soundSwitch.frame.size.height, soundSwitch.frame.size.width);
            
            UILabel *vibrateLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 140, 200, 40)];
            vibrateLabel.text = @"Vibrate";
            vibrateLabel.font = [UIFont systemFontOfSize:18.0];
            UISwitch *vibrateSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(210, 145, 50, 40)];
            [vibrateSwitch addTarget:self action:@selector(toggleVibrate:) forControlEvents:UIControlEventValueChanged];
            [vibrateSwitch setOn:vibrateOn];
            
            // Add a line between Alert and Vibrate
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(40.0, 135.0)];
            [path addLineToPoint:CGPointMake(280.0, 135.0)];
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = [path CGPath];
            shapeLayer.strokeColor = [themeNavBar CGColor];
            shapeLayer.lineWidth = 1.0;
            shapeLayer.fillColor = [[UIColor clearColor] CGColor];
            
            [cell.layer addSublayer:shapeLayer];
            
            [cell addSubview:alertInfo];
            [cell addSubview:soundLabel];
            [cell addSubview:soundSwitch];
            [cell addSubview:vibrateLabel];
            [cell addSubview:vibrateSwitch];

            break;
        }
        case 1:
        {
            title.text = @"Units";
            
            unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 60, 100, 40)];
            unitLabel.text = unitSelected;
            unitLabel.font = [UIFont systemFontOfSize:18.0];
            
            NSArray *unitArray = [NSArray arrayWithObjects:@"Metric", @"Imperial", nil];
            UISegmentedControl *unitSegmentedControl = [[UISegmentedControl alloc] initWithItems:unitArray];
            unitSegmentedControl.frame = CGRectMake(100, 60, 170, 40);
            unitSegmentedControl.tintColor = themeNavBar;
            
            if ([unitSelected  isEqual:@"kg"]) {
                NSLog(@"kg");
                unitSegmentedControl.selectedSegmentIndex = 0;
            } else {
                NSLog(@"lbs");
                unitSegmentedControl.selectedSegmentIndex = 1;
            }
            
            [unitSegmentedControl addTarget:self action:@selector(pickUnit:) forControlEvents:UIControlEventValueChanged];
            
            [cell addSubview:unitLabel];
            [cell addSubview:unitSegmentedControl];
        }
        default:
        {
            break;
        }
    }
    
    [cell.contentView addSubview:title];
    [cell.contentView addSubview:titleUnderline];
    
    // For rounded corner cells
    cell.layer.cornerRadius = 8.0f;
    cell.layer.masksToBounds = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    switch (indexPath.row) {
        case 0:
            // Sound
            return 200.0;
            break;
        case 1:
            // Units
            return 140.0;
            break;
        default:
            break;
    }
    
    return 112.0;
}

// Sound toggle (UISwitch)
-(void)toggleSound:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    soundOn = !soundOn;

    [self setUserDefaults:self];
}

// Vibrate toggle (UISwitch)
-(void)toggleVibrate:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    vibrateOn = !vibrateOn;
    
    [self setUserDefaults:self];
}

// Unit segment control (English/Metric)
- (void)pickUnit:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            unitSelected = @"kg";
            break;
        case 1:
            unitSelected = @"lbs";
            break;
        default:
            break;
    }
    
    unitLabel.text = unitSelected;
    
    [self setUserDefaults:self];
}

/* Save settings to user default */
- (IBAction)setUserDefaults:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:unitSelected forKey:@"units"];
    [defaults setBool:soundOn forKey:@"playSound"];
    [defaults setBool:vibrateOn forKey:@"vibrate"];
    
    [defaults synchronize];
}

/* Get the saved settings */
- (void)getUserDefaults
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    unitSelected = [defaults objectForKey:@"units"];
    soundOn = [defaults boolForKey:@"playSound"];
    vibrateOn = [defaults boolForKey:@"vibrate"];
}

@end
