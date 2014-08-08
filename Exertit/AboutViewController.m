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

// Can only change the frame here (not in viewDidLoad because the views are not set yet)
- (void)viewDidLayoutSubviews {
    if (!IS_IPHONE_5) {
        self.logo.frame = CGRectMake(38, 71, 241, 70);
        
        self.text1.frame = CGRectMake(self.text1.frame.origin.x, self.text1.frame.origin.y - 30, self.text1.frame.size.width, self.text1.frame.size.height);
        self.text2.frame = CGRectMake(self.text2.frame.origin.x, self.text2.frame.origin.y - 30, self.text2.frame.size.width, self.text2.frame.size.height);
        self.text3.frame = CGRectMake(self.text3.frame.origin.x, self.text3.frame.origin.y - 30, self.text3.frame.size.width, self.text3.frame.size.height);
        self.text4.frame = CGRectMake(self.text4.frame.origin.x, self.text4.frame.origin.y - 30, self.text4.frame.size.width, self.text4.frame.size.height);
        self.text5.frame = CGRectMake(self.text5.frame.origin.x, self.text5.frame.origin.y - 30, self.text5.frame.size.width, self.text5.frame.size.height);
        self.text6.frame = CGRectMake(self.text6.frame.origin.x, self.text6.frame.origin.y - 45, self.text6.frame.size.width, self.text6.frame.size.height);
        self.text7.frame = CGRectMake(self.text7.frame.origin.x, self.text7.frame.origin.y - 45, self.text7.frame.size.width, self.text7.frame.size.height);
        self.text8.frame = CGRectMake(self.text8.frame.origin.x, self.text8.frame.origin.y - 45, self.text8.frame.size.width, self.text8.frame.size.height);

        self.emailButton.frame = CGRectMake(self.emailButton.frame.origin.x, self.emailButton.frame.origin.y - 40, self.emailButton.frame.size.width, self.emailButton.frame.size.height);
        self.version.frame = CGRectMake(self.version.frame.origin.x, self.version.frame.origin.y - 80, self.version.frame.size.width, self.version.frame.size.height);
    }
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
