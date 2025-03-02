//
//  RunIntervalTrainerViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-19.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import "RunIntervalTrainerViewController.h"
#import "GAIDictionaryBuilder.h"

@interface RunIntervalTrainerViewController ()

@end

@implementation RunIntervalTrainerViewController

// Private variables declaration
static int minutesCount = 0;
static int secondsCount = 0;
static bool isTimerRunning = YES, done = NO;
int repetitionCount, repetitionTotal;

// STATES
int const WARM_UP = 0;
int const LOW_INT = 1;
int const HIGH_INT = 2;
int const COOL_DOWN = 3;
int state;

// System sound
SystemSoundID lowIntervalSoundID, highIntervalSoundID, cooldownSoundID, doneSoundID;
bool playSound, vibrate;

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
    
    NSLog(@"\nwarmup = %@\nlow interval = %@\nhigh interval = %@\ncool down = %@\nrepetitions = %@",
          self.warmupDuration, self.lowIntervalDuration, self.highIntervalDuration, self.cooldownDuration, self.repetitions);

    // Convert the string repetition to int and display in repetitionTotal
    repetitionTotal = [self.repetitions intValue];
    
    // Set the total repetitions text
    self.totalRep.text = self.repetitions;
    
    [self initialSetup];
    [self runTimer];
    
    // Color and text customization
    [self.pauseLabel setTitleColor:appleGreen forState:UIControlStateNormal];
    [self.resetLabel setTitleColor:appleRed forState:UIControlStateNormal];
    
    // Cicle button
    self.pauseLabel.layer.cornerRadius = 20.0f;
    self.pauseLabel.layer.borderWidth = 2.0;
    self.pauseLabel.layer.borderColor = self.pauseLabel.titleLabel.textColor.CGColor;
    self.resetLabel.layer.cornerRadius = 20.0;
    self.resetLabel.layer.borderWidth = 2.0;
    self.resetLabel.layer.borderColor = self.resetLabel.titleLabel.textColor.CGColor;
    
    [self setupSystemSounds];
    [self getUserDefaults];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Keep the screen from sleeping in the timer view.
    [UIApplication sharedApplication].idleTimerDisabled = YES;
 
    // Google Analytics
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"RunInterval"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // Allow the screen to sleep since exiting timer view.
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    // Stop the timer
    [self stopRunningTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Initial setup of the starting state and repetition count
-(void)initialSetup
{
    // Skip WARM_UP if not set
    if ( ![self.warmupDuration isEqualToString:@"00:00"]) {
        state = WARM_UP;
    } else {
        state = LOW_INT;
    }
    
    // Set the current repetition to 0
    repetitionCount = 0;
    self.currentRep.text = @"0";
    
    [self setMinuteAndSecondsFromStringTime:[self getTimeInStringFormatFromState]];
    [self displayMinValue:minutesCount andSecValue:secondsCount];
}

// Setup system sounds: add url to array
-(void)setupSystemSounds
{
    NSURL *lowIntervalUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/System/Library/Audio/UISounds/SIMToolkitPositiveACK.caf"]];
    NSURL *highIntervalUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/System/Library/Audio/UISounds/sms-received3.caf"]];
    NSURL *cooldownUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/System/Library/Audio/UISounds/Modern/sms_alert_circles.caf"]];
    NSURL *doneUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/System/Library/Audio/UISounds/alarm.caf"]];

    AudioServicesCreateSystemSoundID((__bridge CFURLRef)lowIntervalUrl, &lowIntervalSoundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)highIntervalUrl, &highIntervalSoundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)cooldownUrl, &cooldownSoundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)doneUrl, &doneSoundID);
}

// Play the sound and/or vibrate depending on user default settings
-(void)playSound:(SystemSoundID)soundID
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (playSound) {
        AudioServicesPlaySystemSound(soundID);
    }
    
    if (vibrate) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

// Get the user default settings for sound
-(void)getUserDefaults
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    playSound = [defaults boolForKey:@"playSound"];
    vibrate = [defaults boolForKey:@"vibrate"];
}

// Called every second when timePicker is active
- (void)timer {

    if (secondsCount == 0 && minutesCount == 0) {
        if (state != COOL_DOWN) {
            if (state == HIGH_INT) {
                // Need to decrement the repetition count
                repetitionCount++;
                self.currentRep.text = [NSString stringWithFormat:@"%d", repetitionCount];
                
                if (repetitionCount == repetitionTotal) {
                    // Skip COOL_DOWN if not set
                    if (![self.cooldownDuration isEqualToString:@"00:00"]) {
                        // Go to cool down
                        state = COOL_DOWN;
                        [self playSound:cooldownSoundID];
                    } else {
                        NSLog(@"------ FINISH WITHOUT COOL DOWN ------");
                        [self endIntervalTrainer];
                        [self playSound:doneSoundID];
                        return;
                    }
                } else {
                    // Go back to low interval
                    state = LOW_INT;
                    [self playSound:lowIntervalSoundID];
                }
            } else {
                // Either in WARM UP or LOW INT state, just increment to next state
                if (state == WARM_UP) {
                    [self playSound:lowIntervalSoundID];
                } else {
                    // Low interval state
                    [self playSound:highIntervalSoundID];
                }
                state++;
            }
            [self setMinuteAndSecondsFromStringTime:[self getTimeInStringFormatFromState]];
        } else {
            // Reached the end of the interval training- disable timer
            NSLog(@"------ FINISH ------");
            [self endIntervalTrainer];
            [self playSound:doneSoundID];
        }
        
    } else if (secondsCount == 0) {
        minutesCount--;
        secondsCount = 59;
    } else {
        secondsCount--;
    }
    
    [self displayMinValue:minutesCount andSecValue:secondsCount];
}

// Return the States time in string format
-(NSString *)getTimeInStringFormatFromState
{
    switch (state) {
        case WARM_UP:
            NSLog(@"++++++ WARM UP");
            self.categoryLabel.text = @"WARM UP";
            self.categoryLabel.backgroundColor = themeOrange;
            return self.warmupDuration;
            break;
        case LOW_INT:
            NSLog(@"++++++ LOW INTERVAL");
            self.categoryLabel.text = @"LOW";
            self.categoryLabel.backgroundColor = themeGreen;
            return self.lowIntervalDuration;
            break;
        case HIGH_INT:
            NSLog(@"++++++ HIGH INTERVAL");
            self.categoryLabel.text = @"HIGH";
            self.categoryLabel.backgroundColor = themeRed;
            return self.highIntervalDuration;
            break;
        case COOL_DOWN:
            NSLog(@"++++++ COOL DOWN");
            self.categoryLabel.text = @"COOL DOWN";
            self.categoryLabel.backgroundColor = themeBlue;
            return self.cooldownDuration;
            break;
        default:
            break;
    }
    return nil;
}

// Set the timer's minute and second from the State's string time
-(void)setMinuteAndSecondsFromStringTime:(NSString *)time
{
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    NSArray *array = [time componentsSeparatedByString:@":"];
    minutesCount = [[array objectAtIndex:0] intValue];
    secondsCount = [[array objectAtIndex:1] intValue];
}

/* Change the display values for the min and sec labels */
-(void)displayMinValue:(int)minutes andSecValue:(int)seconds {
//    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    self.minDisplay.text = [NSString stringWithFormat:@"%02d", minutes];
    self.secDisplay.text = [NSString stringWithFormat:@"%02d", seconds];
}

/* Finish interval trainer */
-(void)endIntervalTrainer
{
    done = YES;
    
    // Stop the timer
    [self stopRunningTimer];
    
    [self.pauseLabel setTitle:@"START" forState:UIControlStateNormal];
    
    self.categoryLabel.text = @"DONE!";
    self.categoryLabel. backgroundColor = [UIColor lightGrayColor];
}

/* PAUSE and RESET timer buttons*/

- (IBAction)pauseTimer:(id)sender {
    if (done) {
        // Already finished the interval trainer, need to reset back to initial settings
        [self initialSetup];
    }
    if (isTimerRunning) {
        // Stop the timer
        [self stopRunningTimer];
        
        // Change label to START
        [self.pauseLabel setTitle:@"RESUME" forState:UIControlStateNormal];

    } else {
        // Start the timer
        [self runTimer];
        
        // Change label to PAUSE
        [self.pauseLabel setTitle:@"PAUSE" forState:UIControlStateNormal];
    }
}

- (IBAction)resetTimer:(id)sender {
    // Stop the timer
    [self stopRunningTimer];
    
    // Reset back to initial setup
    [self initialSetup];
    
    // Change the PAUSE button to START
    [self.pauseLabel setTitle:@"START" forState:UIControlStateNormal];
}

// Run timer
-(void)runTimer
{
    self.secondsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target: self
                                                       selector:@selector(timer)
                                                       userInfo:nil
                                                        repeats:YES];
    isTimerRunning = YES;
}

// Stop timer
-(void)stopRunningTimer
{
    [self.secondsTimer invalidate];
    self.secondsTimer = nil;
    
    isTimerRunning = NO;
}

@end
