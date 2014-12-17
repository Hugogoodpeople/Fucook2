//
//  InAppsCell.m
//  Fucook2
//
//  Created by Hugo Costa on 16/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "InAppsCell.h"
#import <Social/Social.h>

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
    
    // esta parte funciona correctamente mas tem de abrir logo ou twitter ou facebook
    /*
     // este cosigo deixa o utilizador escolher qual o tipo de ferramenta pretende usar para partilhar o desejado
     UIImage *postImage = self.imagemReceita.image;
     
     NSArray *activityItems = @[@"texto exemplo", postImage];
     
     UIActivityViewController *activityController =
     [[UIActivityViewController alloc]
     initWithActivityItems:activityItems
     applicationActivities:nil];
     
     [self.delegate presentViewController:activityController
     animated:YES completion:nil];
     */
    
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
    
    [self.delegate presentViewController:composeController
                                animated:YES completion:nil];
}

@end