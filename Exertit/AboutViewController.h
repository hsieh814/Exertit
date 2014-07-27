//
//  AboutViewController.h
//  Exertit
//
//  Created by Lena Hsieh on 2014-07-27.
//  Copyright (c) 2014 hsieh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;

- (IBAction)emailAction:(id)sender;

@end
