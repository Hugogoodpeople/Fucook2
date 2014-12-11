//
//  ReceitaCell.m
//  Fucook2
//
//  Created by Hugo Costa on 10/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "ReceitaCell.h"
#import <Social/Social.h>

@implementation ReceitaCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    // Configure the view for the selected state
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    
    
    [self.contentView addGestureRecognizer:swipeLeft];
    [self.contentView addGestureRecognizer:swipeRight];

    
}

- (void)handlePanGesture:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"Direcção do gesto %d",sender.direction );
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        // se moveu para cima tem de fazer scroll
        [self irParaEsquerda];
        NSLog(@"moveu para cima ");
    }
    else
    {
        // para baixo tem de voltar ao estado inicial
        [self irParaDireita];
        NSLog(@"moveu para baixo ");
    }
}

-(void)irParaEsquerda
{
    int height = self.viewMovel.frame.size.height;
    int width = self.viewMovel.frame.size.width;
    
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.viewMovel setFrame:CGRectMake(-140, 0, width, height)];
    }];
    
    int altura = [[UIScreen mainScreen] bounds].size.height;
    
    NSLog(@"Tamanho da movel %d %d altura=%d", width, height, altura);
    
}

-(void)irParaDireita
{
    
    
    int height = self.viewMovel.frame.size.height;
    int width = self.viewMovel.frame.size.width;
    
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.viewMovel setFrame:CGRectMake(0, 0, width, height)];
    }];
    
    int altura = [[UIScreen mainScreen] bounds].size.height;
    
    NSLog(@"Tamanho da movel %d %d altura=%d", width, height, altura);
    
}






- (IBAction)clickEdit:(id)sender
{
    NSLog(@"Edit");
    if (self.delegate) {
        [self.delegate performSelector:@selector(editarReceita:) withObject:self.receita afterDelay:0.2f];
    }
    [self irParaDireita];
}

- (IBAction)clickCalendario:(id)sender
{
    NSLog(@"Calendario");
    if (self.delegate) {
        [self.delegate performSelector:@selector(calendarioReceita:) withObject:self.receita.managedObject afterDelay:0.2f];
    }
    [self irParaDireita];
}
- (IBAction)clickCarrinho:(id)sender
{
    NSLog(@"Carrinho");
    if (self.delegate) {
        [self.delegate performSelector:@selector(adicionarReceita:) withObject:self.receita afterDelay:0.2f];
    }
    [self irParaDireita];
}

- (IBAction)clickDelete:(id)sender
{
    NSLog(@"Remover Receita");
    if (self.delegate) {
        [self.delegate performSelector:@selector(ApagarReceita:) withObject:self.receita.managedObject afterDelay:0.2f];
    }
    [self irParaDireita];
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
    
    [composeController setInitialText:@"Just found this great website"];
    [composeController addImage:self.imagemReceita.image];
    [composeController addURL: [NSURL URLWithString:
                                @"http://www.fucook.pt"]];
    
    [self.delegate presentViewController:composeController
                       animated:YES completion:nil];
}




@end
