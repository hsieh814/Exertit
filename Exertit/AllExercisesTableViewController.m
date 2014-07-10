//
//  AllExercisesTableViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 3/5/2014.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <iAd/iAd.h>
#import "AllExercisesTableViewController.h"
#import "SWRevealViewController.h"
#import "Exercise.h"
#import "ExerciseCell.h"
#import "WorkoutConfigTableViewController.h"

@interface AllExercisesTableViewController () <ExerciseCellDelegate>

@end

@implementation AllExercisesTableViewController {
    ADBannerView *_bannerView;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

// called the first time we enter the view
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    if (_sidebarButton != nil) {
        
        // Slide out menu customization
        _sidebarButton.target = self.revealViewController;
        _sidebarButton.action = @selector(revealToggle:);
        // Set the gesture
        [self.revealViewController panGestureRecognizer];
        [self.revealViewController tapGestureRecognizer];
        
        // Tableview customization
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = mediumBlue;
        
        // Make tableview start lower
        UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
        self.tableView.contentInset = inset;
        
//        // Allow iAds
//        self.canDisplayBannerAds = YES;
//        // On iOS 6 ADBannerView introduces a new initializer, use it when available.
//        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
//            _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
//        } else {
//            _bannerView = [[ADBannerView alloc] init];
//        }
//        _bannerView.delegate = self;
//        
//        [self.view insertSubview:_bannerView atIndex:1];
    }
}

// called everytime we enter the view
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Fetch all exercises
    [self fetchAllExercises];
    
    // Reload table
    [self.tableView reloadData];
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
    return self.exerciseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    ExerciseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExerciseCell"];
    Exercise *exercise = self.exerciseList[indexPath.row];
    cell.exerciseName.text = exercise.exerciseName;
    cell.exerciseName.textColor = themeNavBar4;
    
    cell.layer.cornerRadius = 8.0f;
    cell.layer.masksToBounds = YES;
    
    // For swipe utility buttons
    cell.itemText = cell.exerciseName.text;
    cell.delegate = self;

    UIImage *img = [self checkExerciseCategory:[exercise.category integerValue]];
    [cell.categoryImage setImage:img];
    
    return cell;
}

- (UIImage *)checkExerciseCategory:(NSInteger)tag
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    switch (tag) {
        case 1:
            return [UIImage imageNamed:@"category_blue.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"category_red.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"category_yellow.png"];
            break;
        case 4:
            return [UIImage imageNamed:@"category_green.png"];
            break;
        default:
            break;
    }
    
    return nil;
}

//// Change the background color of cells
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    cell.backgroundColor = cellBlue;
//}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/* Called when a row is selected */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([self.presentingViewController isKindOfClass:[SWRevealViewController class]]) {
        // Previous view controller is the WorkoutConfigViewController. Need to pass the selected exercise back.
        Exercise *selectedExercise = self.exerciseList[indexPath.row];
        [self.delegate allExercisesViewControllerDidSelectWorkout:self didSelectExercise:selectedExercise];
    } else {
        // Hide the utility buttons of the active cell when tapping on cell.
        [self.activeCell closeActivatedCells];
    }

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
    NSLog(@"[%@] %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), segue.identifier);
    
    if ([segue.identifier isEqualToString:@"AddExercise"]) {
        NSLog(@"AddExercise segue");
        
    } else if ([segue.identifier isEqualToString:@"EditExercise"]) {
        NSLog(@"EditExercise segue");
        
        UINavigationController *navigationController = segue.destinationViewController;
        NewExerciseTableViewController *newExerciseTableViewController = (NewExerciseTableViewController *)navigationController.childViewControllers[0];
        newExerciseTableViewController.title = @"Edit Exercise";
        Exercise *selectedExercise = self.exerciseList[self.indexPath.row];
        newExerciseTableViewController.exercise = selectedExercise;
    }
}

/* Fetch all exercises using MagicalRecords */
- (void)fetchAllExercises
{
    self.exerciseList = [[Exercise findAllSortedBy:@"exerciseName" ascending:YES] mutableCopy];
}

/* Save data to the store */
- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

#pragma mark - SwipeableCellDelegate
- (void)editButtonActionForItemText:(NSString *)itemText {
    NSLog(@"AllExercises- Edit for %@", itemText);
    
    [self performSegueWithIdentifier:@"EditExercise" sender:self];
}

- (void)deleteButtonActionForItemText:(NSString *)itemText {
    NSLog(@"AllExericses- Delete for %@", itemText);
    
    // Remove Exercise object (the active cell currently showing the utility buttons)
    Exercise *exerciseToRemove = self.exerciseList[self.indexPath.row];
    [exerciseToRemove deleteEntity];
    
    // Remove the associated ExerciseSetting objects
    // Change NSSet to NSArray to get object at index
    NSArray *exerciseSettingArray = [exerciseToRemove.highLevelExercise allObjects];
    
    if (sizeof(exerciseSettingArray) > 0) {
        for (int i = 0; i < [exerciseSettingArray count]; i++) {
            ExerciseSetting *exerciseSetting = exerciseSettingArray[i];
            [exerciseSetting deleteEntity];
        }
    }
    
    [self saveContext];
    
    [self.exerciseList removeObjectAtIndex:self.indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    self.activeCell = (ExerciseCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];

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
