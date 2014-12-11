//
//  MealPlanerCell.m
//  Fucook
//
//  Created by Hugo Costa on 14/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "MealPlanerCell.h"

@implementation MealPlanerCell

- (void)awakeFromNib {
    // Initialization code
      [self setupViewMovel];
    
}

// tenho de fazer uma verificaçao para os diferentes tamanhos de ecra
-(void)setupViewMovel
{
    // para as sombras
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self setupViewMovel];
    
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    
    
    [self.contentView addGestureRecognizer:swipeDown];
    [self.contentView addGestureRecognizer:swipeUp];
    
     // [self setupViewMovel];
    
}


- (void)handlePanGesture:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"Direcção do gesto %d",sender.direction );
    if (sender.direction == UISwipeGestureRecognizerDirectionUp)
    {
        // se moveu para cima tem de fazer scroll
        [self irParaTopo];
        NSLog(@"moveu para cima ");
    }
    else
    {
        // para baixo tem de voltar ao estado inicial
        [self irParaFundo];
        NSLog(@"moveu para baixo ");
    }
}

-(void)irParaTopo
{
    int x = self.viewMovel.frame.origin.x;
    
    int height = self.viewMovel.frame.size.height;
    int width = self.viewMovel.frame.size.width;
    
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.viewMovel setFrame:CGRectMake(x, -35, width, height)];
    }];
    
    int altura = [[UIScreen mainScreen] bounds].size.height;
    
    NSLog(@"Tamanho da movel %d %d altura=%d", width, height, altura);
    
}

-(void)irParaFundo
{
    
    
    int x = self.viewMovel.frame.origin.x;
    
    int height = self.viewMovel.frame.size.height;
    int width = self.viewMovel.frame.size.width;
    
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.viewMovel setFrame:CGRectMake(x, 15, width, height)];
    }];
    
    int altura = [[UIScreen mainScreen] bounds].size.height;
    
    NSLog(@"Tamanho da movel %d %d altura=%d", width, height, altura);
}

- (IBAction)clickDelete:(id)sender {
    if (self.delegate) {
        [self.delegate performSelectorInBackground:@selector(apagarReceita:) withObject:self.receita];
    }
}

- (IBAction)clickCalendario:(id)sender {
    
    if (self.delegate) {
        [self.delegate performSelectorInBackground:@selector(reagendarReceita:) withObject:self.receita];
    }
    
}

- (IBAction)clickCarrinho:(id)sender {
    if (self.delegate) {
        [self.delegate performSelector:@selector(adicionarReceita:) withObject:self.receita];
    }
}
@end
