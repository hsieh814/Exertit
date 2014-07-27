//
//  AboutViewController.m
//  Exertit
//
//  Created by Lena Hsieh on 2014-07-27.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"

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
    
    // Contact Us button customization
    self.emailButton.backgroundColor = [UIColor whiteColor];
    self.emailButton.layer.borderColor = themeNavBar4.CGColor;
    self.emailButton.layer.borderWidth = 2.0;
    self.emailButton.layer.cornerRadius = 20.0f;
    [self.emailButton setTitleColor:themeNavBar4 forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Email me action
- (IBAction)emailAction:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;
    [mailController setToRecipients:[NSArray arrayWithObject:@"exertit.app@gmail.com"]];
    [mailController setTitle:@"Email Exertit"];
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
