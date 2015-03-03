//
//  Settings.m
//  Fucook
//
//  Created by Hugo Costa on 07/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "Settings.h"
#import "UnidadeMedida.h"
#import "WebView.h"
#import "ShareFucook.h"


@interface Settings ()
{
    
    MFMailComposeViewController *mailComposer;
}

@end

@implementation Settings

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Settings";
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 540)];
    
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 10, 40)];
    [buttonback addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft1"] forState:UIControlStateNormal];
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickFechar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)clickSettings:(id)sender {
    [self.navigationController pushViewController:[UnidadeMedida new] animated:YES];
}

- (IBAction)clickUserGuide:(id)sender
{
    WebView * web = [WebView new];
    
    web.titulo = @"User Guide";
    web.url = @"http://fucook.com";
    
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)clickAboutUs:(id)sender
{
    WebView * web = [WebView new];
    
    web.titulo = @"About us";
    web.url = @"http://fucook.com/aboutus";
    
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)clickRate:(id)sender {
    // rate da apps
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id946087703"]];
}

- (IBAction)clickReportBug:(id)sender {
    [self sendMail:nil];
}

- (IBAction)clickShare:(id)sender {
    
     ShareFucook * share = [ShareFucook new];
     share.delegate = nil;
     share.isInInApps = NO;
     share.modalPresentationStyle = UIModalPresentationOverCurrentContext;
     [self presentViewController:share animated:YES completion:^{
     [UIView animateWithDuration:0.2 animations:^{
     share.viewEscura.alpha = 0.6;
     }];}];
    
}


-(void)sendMail:(id)sender{
    mailComposer = [[MFMailComposeViewController alloc]init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setSubject:@"Report a Bug"];
    
    NSArray *usersTo = [NSArray arrayWithObject: @"support@fucook.com"];
    [mailComposer setToRecipients:usersTo];
    
    NSString * stringEnviar = @"";
    
    [mailComposer setMessageBody:stringEnviar isHTML:YES];
    
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        NSLog(@"Result : %d",result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
