//
//  InAppsCell.m
//  Fucook2
//
//  Created by Hugo Costa on 16/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "InAppsCell.h"
#import <Social/Social.h>
#import "ShareFucook.h"

@implementation InAppsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

// tenho de fazer #import <Social/Social.h> para funcionar
- (IBAction)partilharFacebook:(id)sender {
    
    
    ShareFucook * share = [ShareFucook new];
    share.delegate = self.delegate;
    share.livro = self.livro;
    share.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.delegate presentViewController:share animated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
            share.viewEscura.alpha = 0.6;
        }];}];

    
    
    // esta parte funciona correctamente mas tem de abrir logo ou twitter ou facebook
    
    /*
     // este cosigo deixa o utilizador escolher qual o tipo de ferramenta pretende usar para partilhar o desejado
     UIImage *postImage = [self imageWithView:self.viewMovel];
     
     NSArray *activityItems = @[@"Just found this great book on fucook",[NSURL URLWithString:@"http://www.fucook.com"], postImage];
     
     UIActivityViewController *activityController =
     [[UIActivityViewController alloc]
     initWithActivityItems:activityItems
     applicationActivities:nil];
    

    activityController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                                                         UIActivityTypeMessage,
                                                                         UIActivityTypeMail,
                                                                         UIActivityTypePrint,
                                                                         UIActivityTypeCopyToPasteboard,
                                                                         UIActivityTypeAssignToContact,
                                                                         UIActivityTypeSaveToCameraRoll,
                                                                         UIActivityTypeAddToReadingList,
                                                                         UIActivityTypePostToFlickr,
                                                                         UIActivityTypePostToVimeo,
                                                                         UIActivityTypePostToTencentWeibo,
                                                                         UIActivityTypeAirDrop
                                                                         ];
    
    
    [activityController setCompletionHandler:^(NSString *activityType, BOOL completed) {
        
        if (completed) {
            if (self.delegate) {
                [self.delegate performSelector:@selector(comprarLivro:) withObject:self.livro];
            }
        }
        
    }];
     
     [self.delegate presentViewController:activityController
     animated:YES completion:nil];
    
  
    */
    
    /*
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        // Device is able to send a Twitter message
    }
    
    SLComposeViewController *composeController = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [composeController setInitialText:@"Just found this great book"];
    [composeController addImage:self.imagemLivro.image];
    [composeController addURL: [NSURL URLWithString:
                                @"http://www.fucook.com"]];
    
    [self.delegate presentViewController:composeController
                                animated:YES completion:nil];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            
            NSLog(@"cancele");
            
        } else
            
        {
            NSLog(@"post to facebook done");
            // tenho de adicionar o livro a lista de livros do utilizador
            if (self.delegate) {
                [self.delegate performSelector:@selector(comprarLivro:) withObject:self.livro];
            }
        }
    };
    composeController.completionHandler =myBlock;
     
     */

}

- (IBAction)partilhaTwitter:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        // Device is able to send a Twitter message
    }
    
    SLComposeViewController *composeController = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [composeController setInitialText:@"Just found this great book"];
    [composeController addImage:self.imagemLivro.image];
    [composeController addURL: [NSURL URLWithString:
                                @"http://www.fucook.com"]];
    

    
    [self.delegate presentViewController:composeController animated:YES completion:nil];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
    {
        if (result == SLComposeViewControllerResultCancelled)
        {
            NSLog(@"cancele");
        } else
            
        {
            NSLog(@"post to twitter done");
            // tenho de adicionar o livro a lista de livros do utilizador
            if (self.delegate) {
                [self.delegate performSelector:@selector(comprarLivro:) withObject:self.livro];
            }
        }
        
    };
    composeController.completionHandler = myBlock;

}

-(UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


- (IBAction)clickAddLivro:(id)sender
{
    if (self.delegate) {
        [self.delegate performSelector:@selector(comprarLivro:) withObject:self.livro];
    }
}
@end
