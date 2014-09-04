//
//  AppDelegate.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2013-12-30.
//  Copyright (c) 2013 hsieh. All rights reserved.
//

#import "AppDelegate.h"
#import "HowToViewController.h"
#import "GAI.h"
#import "Workout.h"
#import "Exercise.h"
#import "ExerciseSetting.h"
#import "iRate.h"

@implementation AppDelegate {
}

@synthesize window = _window;

+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 3;
    [iRate sharedInstance].usesUntilPrompt = 3;
    [iRate sharedInstance].remindPeriod = 1;
    [iRate sharedInstance].message = @"If you enjoy using Exert It, please take a moment to rate it. \nIt would make my day! \nThanks for your support!";
    [iRate sharedInstance].updateMessage = @"I know you already rated, but it would be awesome if you rate it again for my updated version. \nThanks for your support!";
    [iRate sharedInstance].promptForNewVersionIfUserRated = YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Setup Core Data with Magical Record
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Data"];
    
    // Change the navigation bar color to the theme color, and the text to white
    [[UINavigationBar appearance] setBarTintColor:themeNavBar];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // Grab thes default values for NSUserDefaults
    NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"defaultPrefs" ofType:@"plist"];
    NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];
    
    // Override the page view indicators
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];

    /*************** INTERNAL: For testing initial launch ***************/
    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HasLaunched"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    /*********************************************************************/
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunched"]) {
        // Display How-To Guide
        [self replaceRootViewWithTutorial];
        
        // Pre-load Demo Workout
        [self preloadData];
    }
    
    // Google Analytics
    [self initializeGoogleAnalytics];
    
    return YES;
}

// Replace the root view controller with the How-To Guide
- (void)replaceRootViewWithTutorial
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    HowToViewController *split = [storyboard instantiateViewControllerWithIdentifier:@"HowTo"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = split;
}

// Pre-load with a Demo Workout from Workout.json
- (void)preloadData
{
    NSError* err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"DemoWorkout" ofType:@"json"];
    NSArray* Workouts = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                        options:kNilOptions
                                                          error:&err];
    NSLog(@"Imported Workouts: %@", Workouts);
    
    [Workouts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Workout *workout = [Workout createEntity];
        workout.workoutName = [obj objectForKey:@"workoutName"];
        
        NSArray *array = [obj objectForKey:@"exerciseSetting"];
        NSLog(@"Imported array: %@", array);
        
        NSMutableArray *settings = [[NSMutableArray alloc] init];
        for (id object in array) {
            ExerciseSetting *exerciseSetting = [ExerciseSetting createEntity];
            exerciseSetting.index = [object objectForKey:@"index"];
            exerciseSetting.reps = [object objectForKey:@"reps"];
            exerciseSetting.sets = [object objectForKey:@"sets"];
            exerciseSetting.weight = [object objectForKey:@"weight"];
            
            Exercise *exercise = [Exercise createEntity];
            exercise.exerciseName = [object objectForKey:@"exerciseName"];
            exercise.category = [object objectForKey:@"category"];
            
            exerciseSetting.baseExercise = exercise;
            
            [settings addObject:exerciseSetting];
        }
        
        workout.exerciseGroup = [NSSet setWithArray:settings];
        
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    }];
}

// Google Analytics setup
- (void)initializeGoogleAnalytics
{
    // Initialize tracker
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-54254442-2"];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIAppVersion value:version];
    [tracker set:kGAISampleRate value:@"50.0"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
