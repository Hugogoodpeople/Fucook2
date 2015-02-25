//
//  IngredienteCellTableViewCell.m
//  Fucook
//
//  Created by Hugo Costa on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "IngredienteCellTableViewCell.h"
#import "UIImage+ImageEffects.h"

@implementation IngredienteCellTableViewCell

-(UIImage *)blurredSnapshot:(UIView *)view
{
    
    // Now apply the blur effect using Apple's UIImageEffect category
    //UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
    UIImage *blurredSnapshotImage = [[self imageWithView:self] applyBlurWithRadius:2 tintColor:[UIColor clearColor] saturationDeltaFactor:1 maskImage:nil];
    
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


- (void)awakeFromNib {
    // Initialization code
    
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (!self.blur && self.isFromInApps) {
        // Configure the view for the selected state
        UIImageView * imagem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imagem.image = [self blurredSnapshot:self.contentView];
        
        self.blur = imagem.image;
        imagem.userInteractionEnabled = YES;
        
        [self.contentView addSubview:imagem];
    }

}


-(void)addRemove:(BOOL)selecionado
{
    if (selecionado)
    {
        [self.imgAddRemove setImage:[UIImage imageNamed:@"icoadd.png"]];
      
        if (self.delegate) {
            [self.delegate performSelectorInBackground:@selector(deleteIngrediente:) withObject:self.ingrediente];
        }
        self.labelAddRemove.text = @"Removed from shopping list";
        
    }
    else
    {
        [self.imgAddRemove setImage:[UIImage imageNamed:@"icoremove.png"]];
        if (self.delegate) {
            [self.delegate performSelectorInBackground:@selector(saveIngrediente:) withObject:self.ingrediente];
        }
        self.labelAddRemove.text = @"Added to shopping list";
    }
    
    self.onCart = selecionado;
    
    
}


- (IBAction)clickAddRemove:(id)sender
{
    self.ingrediente.selecionado = self.onCart;
    self.onCart = !self.onCart;
    [self addRemove:self.onCart];
    
    // tenho de fazer 2 animaçoes aqui
    [UIView animateWithDuration:0.2 animations:^{
        self.viewAddRemove.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.viewAddRemove.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }];

}
@end
