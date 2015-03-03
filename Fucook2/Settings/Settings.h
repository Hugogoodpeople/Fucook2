//
//  Settings.h
//  Fucook
//
//  Created by Hugo Costa on 07/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface Settings : UIViewController <MFMailComposeViewControllerDelegate>
- (IBAction)clickFechar:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)clickSettings:(id)sender;
- (IBAction)clickUserGuide:(id)sender;
- (IBAction)clickAboutUs:(id)sender;
- (IBAction)clickRate:(id)sender;
- (IBAction)clickReportBug:(id)sender;
- (IBAction)clickShare:(id)sender;

@end
