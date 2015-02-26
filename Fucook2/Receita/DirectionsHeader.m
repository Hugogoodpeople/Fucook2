//
//  DirectionsHeader.m
//  Fucook2
//
//  Created by Hugo Costa on 10/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "DirectionsHeader.h"
#import "UIImage+ImageEffects.h"

@interface DirectionsHeader ()

@end

@implementation DirectionsHeader

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!self.blur && self.isFromInApps)
    {
        // Configure the view for the selected state
        UIImageView * imagem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
        imagem.image = [self blurredSnapshot:self.view];
        
        self.blur = imagem.image;
        
        [self.view addSubview:imagem];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage *)blurredSnapshot:(UIView *)view
{
    
    // Now apply the blur effect using Apple's UIImageEffect category
    //UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
    UIImage *blurredSnapshotImage = [[self imageWithView:self.view] applyBlurWithRadius:2 tintColor:[UIColor clearColor] saturationDeltaFactor:1 maskImage:nil];
    
    // Be nice and clean your mess up
    UIGraphicsEndImageContext();
    
    return blurredSnapshotImage;
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


@end
