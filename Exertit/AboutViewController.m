//
//  AboutViewController.m
//  Exertit
//
//  Created by Lena Hsieh on 2014-07-27.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"
#import "GAIDictionaryBuilder.h"
#import "iRate.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    
    // Slide out menu customization
    _sidebarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"slide_menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = _sidebarButton;
    // Set the gesture
    [self.revealViewController panGestureRecognizer];
    [self.revealViewController tapGestureRecognizer];
    
    // View customization
    self.view.backgroundColor = mediumBlue;
    
    // Rate App and Contact Us button customization
    self.rateButton.backgroundColor = [UIColor whiteColor];
    self.rateButton.layer.borderColor = themeNavBar.CGColor;
    self.rateButton.layer.borderWidth = 2.0;
    self.rateButton.layer.cornerRadius = 20.0f;
    [self.rateButton setTitleColor:themeNavBar forState:UIControlStateNormal];
    self.contactButton.backgroundColor = [UIColor whiteColor];
    self.contactButton.layer.borderColor = themeNavBar.CGColor;
    self.contactButton.layer.borderWidth = 2.0;
    self.contactButton.layer.cornerRadius = 20.0f;
    [self.contactButton setTitleColor:themeNavBar forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    // Google Analytics
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"About"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

// Can only change the frame here (not in viewDidLoad because the views are not set yet)
- (void)viewDidLayoutSubviews {
    
    [self.scrollView setContentSize:CGSizeMake(320, 520)];
    
    if (IS_IPHONE_5) {
        self.scrollView.scrollEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Rate app action
- (IBAction)rateAction:(id)sender {
    [[iRate sharedInstance] openRatingsPageInAppStore];
}

// Email me action
- (IBAction)emailAction:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;
    [mailController setToRecipients:[NSArray arrayWithObject:@"support@caffethread.com"]];
    [mailController setTitle:@"Email Exert It"];
	[mailController setSubject:@"Question/feedback"];
	[self presentViewController:mailController animated:YES completion:NULL];
}

#pragma mark - MFMailComposeViewController delegate methods

//Called after the mail intergace is closed
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
