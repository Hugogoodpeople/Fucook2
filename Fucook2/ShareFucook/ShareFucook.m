//
//  ShareFucook.m
//  Fucook2
//
//  Created by Hugo Costa on 23/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "ShareFucook.h"
#import <Social/Social.h>

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
    //Remember Image must be larger than 612x612 size if not resize it.
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        NSString *documentDirectory=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *saveImagePath=[documentDirectory stringByAppendingPathComponent:@"Image.ig"];
        NSData *imageData=UIImagePNGRepresentation(self.livro.imagem);
        [imageData writeToFile:saveImagePath atomically:YES];
        
        NSURL *imageURL=[NSURL fileURLWithPath:saveImagePath];
        
        UIDocumentInteractionController *docController=[[UIDocumentInteractionController alloc]init];
        docController.delegate=self;
        docController.UTI=@"com.instagram.photo";
        
        docController.annotation=[NSDictionary dictionaryWithObjectsAndKeys:@"Image Taken via @App",@"InstagramCaption", nil];
        
        [docController setURL:imageURL];
        
        
        [docController presentOpenInMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];  //Here try which one is suitable for u to present the doc Controller. if crash occurs
        
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"warning" message:@"App not found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
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
