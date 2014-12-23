//
//  ShareFucook.m
//  Fucook2
//
//  Created by Hugo Costa on 23/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "ShareFucook.h"
#import <Social/Social.h>
#import "DMActivityInstagram.h"

@interface ShareFucook ()

@end

@implementation ShareFucook

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCancel:)];
    
    [self.viewEscura addGestureRecognizer:tapGestureRecognizer];
    
    self.viewButtons.layer.cornerRadius = 5;
    self.viewButtons.clipsToBounds = YES;
    
    self.viewCancel.layer.cornerRadius = 5;
    self.viewCancel.clipsToBounds = YES;
    
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

- (IBAction)clickFacebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        // Device is able to send a Twitter message
    }
    
    SLComposeViewController *composeController = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [composeController setInitialText:@"Just found this great book"];
    [composeController addImage:self.livro.imagem];
    [composeController addURL: [NSURL URLWithString:
                                @"http://www.fucook.com"]];
    
    
    
    [self presentViewController:composeController animated:YES completion:nil];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
    {
        if (result == SLComposeViewControllerResultCancelled)
        {
            NSLog(@"cancele");
            [self dismissViewControllerAnimated:NO completion:nil];
        } else
            
        {
            NSLog(@"post to Facebook done");
            // tenho de adicionar o livro a lista de livros do utilizador
            if (self.delegate) {
                [self.delegate performSelector:@selector(comprarLivro:) withObject:self.livro];
            }
            
            [self close];
        }
        
    };
    composeController.completionHandler = myBlock;
}

- (IBAction)clickTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        // Device is able to send a Twitter message
    }
    
    SLComposeViewController *composeController = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [composeController setInitialText:@"Just found this great book"];
    [composeController addImage:self.livro.imagem];
    [composeController addURL: [NSURL URLWithString:
                                @"http://www.fucook.com"]];
    
    
    
    [self presentViewController:composeController animated:YES completion:nil];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
    {
        if (result == SLComposeViewControllerResultCancelled)
        {
            NSLog(@"cancele");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else
            
        {
            NSLog(@"post to twitter done");
            // tenho de adicionar o livro a lista de livros do utilizador
            if (self.delegate) {
                [self.delegate performSelector:@selector(comprarLivro:) withObject:self.livro];
            }
            [self close];
        }
        
    };
    composeController.completionHandler = myBlock;
}

- (IBAction)clickInstagram:(id)sender
{
    DMActivityInstagram *instagramActivity = [[DMActivityInstagram alloc] init];
    
    NSArray *activityItems = @[self.livro.imagem, @"CatPaint #catpaint", [NSURL URLWithString:@"http://catpaint.info"]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[instagramActivity]];
    [self presentViewController:activityController animated:YES completion:^{}];
}

- (IBAction)clickCancel:(id)sender
{
    [self close];
}

-(void)close
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.viewEscura setAlpha:0];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
    
    
}
@end
