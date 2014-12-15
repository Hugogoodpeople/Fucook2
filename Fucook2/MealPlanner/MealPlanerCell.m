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
    
    // Configure the view for the selected state
        
        // Configure the view for the selected state
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    
    
    [self.contentView addGestureRecognizer:swipeLeft];
    [self.contentView addGestureRecognizer:swipeRight];
    
    [self.buttonCalendario addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [self.buttonCalendario addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonCarrinho addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [self.buttonCarrinho addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonDelete addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown];
    [self.buttonDelete addTarget:self action:@selector(buttonNormal:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)buttonHighlight:(id)sender
{
    UIButton * button = (UIButton *) sender;
    [button setBackgroundColor:[UIColor colorWithRed:152.0/255.0 green:54.0/255.0 blue:149.0/255.0 alpha:1.0]];
}

-(void)buttonNormal:(id)sender
{
    UIButton * button = (UIButton *) sender;
    [button setBackgroundColor:[UIColor clearColor]];
}

// tenho de fazer uma verificaçao para os diferentes tamanhos de ecra
-(void)setupViewMovel
{
    // para as sombras
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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


- (IBAction)clickDelete:(id)sender {
    if (self.delegate) {
        [self.delegate performSelectorInBackground:@selector(apagarReceita:) withObject:self.receita];
    }
    [self irParaDireita];
}

- (IBAction)clickCalendario:(id)sender {
    
    if (self.delegate) {
        [self.delegate performSelectorInBackground:@selector(reagendarReceita:) withObject:self.receita];
    }
    [self irParaDireita];
}

- (IBAction)clickCarrinho:(id)sender {
    if (self.delegate) {
        [self.delegate performSelector:@selector(adicionarReceita:) withObject:self.receita];
    }
    [self irParaDireita];
}

@end
