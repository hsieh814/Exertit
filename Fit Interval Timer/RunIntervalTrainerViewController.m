//
//  RunIntervalTrainerViewController.m
//  Fit Interval Timer
//
//  Created by Lena Hsieh on 2014-04-19.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "RunIntervalTrainerViewController.h"

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
    
    NSLog(@"state = %d", state);
    self.secondsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target: self
                                                       selector:@selector(timer)
                                                       userInfo:nil
                                                        repeats:YES];
    
}

// Called before exiting the view
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    // Stop the timer
    [self.secondsTimer invalidate];
    self.secondsTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Get the saved default textfields' text */
- (void)getDefaultTextFieldData
{
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.warmupDuration = [defaults objectForKey:@"warmup"];
    self.lowIntervalDuration = [defaults objectForKey:@"lowInterval"];
    self.highIntervalDuration = [defaults objectForKey:@"highInterval"];
    self.cooldownDuration = [defaults objectForKey:@"cooldown"];
    self.repetitions = [defaults objectForKey:@"repetitions"];
    

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

// Called every second when timePicker is active
- (void)timer {

    // Timer
    if (secondsCount == 0 && minutesCount == 0) {
        NSLog(@"--> Next state");
        
        if (state != COOL_DOWN) {
            NSLog(@"Not the end yet");
            if (state == HIGH_INT) {
                // Need to decrement the repetition count
                NSLog(@"decrement repetition count");
                repetitionCount++;
                self.currentRep.text = [NSString stringWithFormat:@"%d", repetitionCount];
                if (repetitionCount == repetitionTotal) {
                    // Skip COOL_DOWN if not set
                    if (![self.cooldownDuration isEqualToString:@"00:00"]) {
                        // Go to cool down
                        NSLog(@"Go to cool down");
                        state = COOL_DOWN;
                    } else {
                        NSLog(@"No cool down set");
                        [self endIntervalTrainer];
                        return;
                    }
                } else {
                    // Go back to low interval
                    NSLog(@"Go back to low interval state");
                    state = LOW_INT;
                }
            } else {
                // Either in WARM UP or LOW INT state, just increment to next state
                state++;
            }
            NSLog(@"state = %d", state);
            [self setMinuteAndSecondsFromStringTime:[self getTimeInStringFormatFromState]];
        } else {
            // Reached the end of the interval training- disable timer
            NSLog(@"end of interval trainer");
            [self endIntervalTrainer];
        }
        
    } else if (secondsCount == 0) {
        NSLog(@"secondsCount is 0");
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
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    switch (state) {
        case WARM_UP:
            NSLog(@"+++ WARM UP");
            self.categoryLabel.text = @"WARM UP";
            self.categoryLabel.textColor = themeBlue;
            return self.warmupDuration;
            break;
        case LOW_INT:
            NSLog(@"+++ LOW INT");
            self.categoryLabel.text = @"LOW";
            self.categoryLabel.textColor = themeGreen;
            return self.lowIntervalDuration;
            break;
        case HIGH_INT:
            NSLog(@"+++ HIGH INT");
            self.categoryLabel.text = @"HIGH";
            self.categoryLabel.textColor = themeRed;
            return self.highIntervalDuration;
            break;
        case COOL_DOWN:
            NSLog(@"+++ COOL DOWN");
            self.categoryLabel.text = @"COOL DOWN";
            self.categoryLabel.textColor = themeBlue;
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
    NSLog(@"[%@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    NSArray *array = [time componentsSeparatedByString:@":"];
    minutesCount = [[array objectAtIndex:0] intValue];
    secondsCount = [[array objectAtIndex:1] intValue];
    
    NSLog(@"minutesCount = %d , secondsCount = %d", minutesCount, secondsCount);
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
    [self.secondsTimer invalidate];
    self.secondsTimer = nil;
    isTimerRunning = NO;
    
    [self.pauseLabel setTitle:@"START" forState:UIControlStateNormal];
    
    self.categoryLabel.text = @"FINISHED";
    self.categoryLabel.textColor = themeBlue;
}

/* PAUSE and RESET timer buttons*/

- (IBAction)pauseTimer:(id)sender {
    if (done) {
        // Already finished the interval trainer, need to reset back to initial settings
        [self initialSetup];
    }
    if (isTimerRunning) {
        // Stop the timer
        [self.secondsTimer invalidate];
        self.secondsTimer = nil;
        
        // Change label to START
        [self.pauseLabel setTitle:@"START" forState:UIControlStateNormal];
        
        isTimerRunning = NO;
        
    } else {
        // Start the timer
        self.secondsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                             target: self
                                                           selector:@selector(timer)
                                                           userInfo:nil
                                                            repeats:YES];
        
        // Change label to PAUSE
        [self.pauseLabel setTitle:@"PAUSE" forState:UIControlStateNormal];
        
        isTimerRunning = YES;
    }
}

- (IBAction)resetTimer:(id)sender {
    // Stop the timer
    [self.secondsTimer invalidate];
    self.secondsTimer = nil;
    
    // Reset back to initial setup
    [self initialSetup];
    
    // Change the PAUSE button to START
    [self.pauseLabel setTitle:@"START" forState:UIControlStateNormal];
    
    isTimerRunning = NO;
}

@end
