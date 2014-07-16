//
//  AllWorkoutsTableViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-01-02.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "AllWorkoutsTableViewController.h"
#import "SWRevealViewController.h"
#import "Workout.h"
#import "WorkoutCell.h"
#import "Exercise.h"
#import "ExerciseSetting.h"
#import "WorkoutViewController.h"

@interface AllWorkoutsTableViewController () <WorkoutCellDelegate>

@end

@implementation AllWorkoutsTableViewController {
    ADBannerView *_bannerView;
    Workout *newWorkout;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

// called the first time we enter the view
- (void)viewDidLoad
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Slide out menu customization
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    // Set the gesture
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
    
    // TableView customization
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = mediumBlue;
    
    // Make tableview start lower
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
//    // Allow iAds
//    self.canDisplayBannerAds = YES;
//    // On iOS 6 ADBannerView introduces a new initializer, use it when available.
//    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
//        _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
//    } else {
//        _bannerView = [[ADBannerView alloc] init];
//    }
//    _bannerView.delegate = self;
//    
//    [self.view insertSubview:_bannerView atIndex:1];
}

// called everytime we enter the view
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Fetch all workouts
    [self fetchAllWorkouts];
    
    // Reload table
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    return YES;
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
    return self.workoutList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    WorkoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkoutCell"];
    Workout *workout = [self.workoutList objectAtIndex:indexPath.row];
    cell.workoutName.text = workout.workoutName;
    cell.workoutName.textColor = themeNavBar4;

    cell.layer.cornerRadius = 8.0f;
    cell.layer.masksToBounds = YES;
    
    cell.itemText = cell.workoutName.text;
    cell.delegate = self;
    
    // Left icon: circle and number of exercises
    cell.workoutIconCircle.layer.cornerRadius = cell.workoutIconCircle.frame.size.height/2;
    cell.workoutIconCircle.layer.masksToBounds = YES;
    cell.workoutIconCircle.layer.borderWidth = 1.0;
    cell.workoutIconCircle.layer.borderColor = themeNavBar4.CGColor;
    cell.workoutIconLabel.text = [NSString stringWithFormat:@"%d", workout.exerciseGroup.count];
    cell.workoutIconLabel.textColor = darkBlue;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if (self.activeCell == nil) {
        [self performSegueWithIdentifier:@"goToWorkout" sender:self];
    } else {
        // Hide the utility buttons of the active cell when tapping on cell.
        [self.activeCell closeActivatedCells];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Return NO if you do not want the specified item to be editable.
    return NO;
}

// Begin scrolling -> hide active cell's utility buttons
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [self.activeCell closeActivatedCells];
}

/* Segue */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if ([segue.identifier isEqualToString:@"AddWorkout"]) {

        
    } else if ([segue.identifier isEqualToString:@"goToWorkout"]) {
        // index of the selected row
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WorkoutViewController *workoutViewController = segue.destinationViewController;
        
        Workout *selectedWorkout = self.workoutList[indexPath.row];
        workoutViewController.workoutName = selectedWorkout.workoutName;
        
        // Set the title of next controller to the workout's name
        workoutViewController.title = selectedWorkout.workoutName;
    }
}

/* Fetch all workouts using MagicalRecords */
- (void)fetchAllWorkouts
{
    self.workoutList = [[Workout findAllSortedBy:@"workoutName" ascending:YES] mutableCopy];
}

/* Save data to the store */
- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

// Add workout bar button is pressed
- (IBAction)addWorkout:(id)sender {
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    newWorkout = [Workout createEntity];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create New Workout"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Create", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    UITextField *alertTextField = [alert textFieldAtIndex:0];
    alertTextField.clearButtonMode = YES;
    alertTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    alertTextField.delegate = self;
    [alertTextField becomeFirstResponder];
    [alert addSubview:alertTextField];
    [alert show];
}

// Called everytime user enters character in textbox; used for setting max length of workout name
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if (textField.text.length >= WORKOUT_MAX_LENGTH && range.length == 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark - SwipeableCellDelegate
- (void)editButtonActionForItemText:(NSString *)itemText {
    NSLog(@"Edit for %@", itemText);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rename Workout"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Rename", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *alertTextField = [alert textFieldAtIndex:0];
    alertTextField.text = itemText;
    alertTextField.clearButtonMode = YES;
    alertTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [alertTextField becomeFirstResponder];
    [alert addSubview:alertTextField];
    [alert show];
}

- (void)deleteButtonActionForItemText:(NSString *)itemText {
    NSLog(@"Delete for %@", itemText);
    
    // Remove the Workout object
    Workout *workoutToRemove = self.workoutList[self.indexPath.row];
    [workoutToRemove deleteEntity];
    
    // Need to also remove the associated ExerciseSetting objects
    NSArray *exerciseSettingArray = [workoutToRemove.exerciseGroup allObjects];
    for (int i = 0; i < [exerciseSettingArray count]; i++) {
        ExerciseSetting *exerciseSetting = exerciseSettingArray[i];
        [exerciseSetting deleteEntity];
    }
    
    [self saveContext];
    
    [self.workoutList removeObjectAtIndex:self.indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if (alert.tag == 1) {
        // Create new workout
        
        if (buttonIndex == alert.cancelButtonIndex)
        {
            // Delete the newly created exercise
            [newWorkout deleteEntity];
        } else {
            if ([[alert textFieldAtIndex:0].text isEqualToString:@""]) {
                // don't save the workout since the name is empty
                [newWorkout deleteEntity];
            } else {
                newWorkout.workoutName = [alert textFieldAtIndex:0].text;
            }
            
            [self saveContext];
            
            // Reload data
            [self viewDidAppear:YES];
        }
        
    }
    else
    {
        // Rename workout
        if (buttonIndex == alert.cancelButtonIndex)
        {
            NSLog(@"CANCEL alert view");
            [self.activeCell closeActivatedCells];
        }
        else
        {
            NSLog(@"RENAME alert view");
            Workout *editWorkout = self.workoutList[self.indexPath.row];
            editWorkout.workoutName = [[alert textFieldAtIndex:0]text];
        
            // Reload data
            [self viewDidAppear:YES];
        }
    }
}

//4
- (void)closeModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Called when showing a cell's utility buttons
- (void)cellDidOpen:(UITableViewCell *)cell
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    self.indexPath = [self.tableView indexPathForCell:cell];
    
    if (self.activeCell != nil) {
        // There is no active cell (no cells with utility buttons showing)
        [self.activeCell closeActivatedCells];
    }
    
    self.activeCell = (WorkoutCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
    
}

// Called when hiding a cell's utility buttons
- (void)cellDidClose:(UITableViewCell *)cell
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Avoid setting activeCell to nil when closing a cell that does isn't showing its utility buttons.
    if (self.activeCell == cell) {
        self.activeCell = nil;
    }
}

#pragma mark - iAdBanner Delegates

//- (void)viewDidLayoutSubviews
//{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
//    
//    // This method will be called whenever we receive a delegate callback
//    // from the banner view.
//    // (See the comments in -bannerViewDidLoadAd: and -bannerView:didFailToReceiveAdWithError:)
//    
//    CGRect contentFrame = self.view.bounds, bannerFrame = CGRectZero;
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//    // If configured to support iOS <6.0, then we need to set the currentContentSizeIdentifier in order to resize the banner properly.
//    // This continues to work on iOS 6.0, so we won't need to do anything further to resize the banner.
//    if (contentFrame.size.width < contentFrame.size.height) {
//        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
//    } else {
//        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
//    }
//    bannerFrame = _bannerView.frame;
//#else
//    // If configured to support iOS >= 6.0 only, then we want to avoid currentContentSizeIdentifier as it is deprecated.
//    // Fortunately all we need to do is ask the banner for a size that fits into the layout area we are using.
//    // At this point in this method contentFrame=self.view.bounds, so we'll use that size for the layout.
//    bannerFrame.size = [_bannerView sizeThatFits:contentFrame.size];
//#endif
//    
//    // Check if the banner has an ad loaded and ready for display.  Move the banner off
//    // screen if it does not have an ad.
//    if (_bannerView.bannerLoaded) {
//        // Visible banner
//        NSLog(@"VISIBLE");
//        contentFrame.size.height -= bannerFrame.size.height;
//        contentFrame.origin.y = bannerFrame.size.height;
//        NSLog(@"%f - %f - %f", self.view.bounds.size.height, contentFrame.size.height, bannerFrame.size.height);
//        bannerFrame.origin.y = 64;//self.view.bounds.size.height - contentFrame.size.height + bannerFrame.size.height/2;
//        
//    } else {
//        // Hide banner
//        NSLog(@"HIDE");
//        bannerFrame.origin.y = -bannerFrame.size.height;//contentFrame.size.height;
//        contentFrame.origin.y = 0;
//    }
//    self.tableView.frame = contentFrame;
//    _bannerView.frame = bannerFrame;
//}
//
//-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
//    NSLog(@"Error in Loading Banner!");
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        // -viewDidLayoutSubviews will handle positioning the banner such that it is either visible
//        // or hidden depending upon whether its bannerLoaded property is YES or NO (It will be
//        // NO if -bannerView:didFailToReceiveAdWithError: was last called).  We just need our view
//        // to (re)lay itself out so -viewDidLayoutSubviews will be called.
//        // You must not call [self.view layoutSubviews] directly.  However, you can flag the view
//        // as requiring layout...
//        [self.view setNeedsLayout];
//        // ...then ask it to lay itself out immediately if it is flagged as requiring layout...
//        [self.view layoutIfNeeded];
//        // ...which has the same effect.
//    }];
//}
//
//-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
//    NSLog(@"iAd Banner will load!");
//}
//
//-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
//    NSLog(@"iAd banner Loaded Successfully!");
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        // -viewDidLayoutSubviews will handle positioning the banner such that it is either visible
//        // or hidden depending upon whether its bannerLoaded property is YES or NO (It will be
//        // YES if -bannerViewDidLoadAd: was last called).  We just need our view
//        // to (re)lay itself out so -viewDidLayoutSubviews will be called.
//        // You must not call [self.view layoutSubviews] directly.  However, you can flag the view
//        // as requiring layout...
//        [self.view setNeedsLayout];
//        // ...then ask it to lay itself out immediately if it is flagged as requiring layout...
//        [self.view layoutIfNeeded];
//        // ...which has the same effect.
//    }];
//}
//
//-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
//    NSLog(@"iAd Banner did finish");
//}

@end
