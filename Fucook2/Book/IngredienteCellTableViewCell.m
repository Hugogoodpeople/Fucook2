//
//  IngredienteCellTableViewCell.m
//  Fucook
//
//  Created by Hugo Costa on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "IngredienteCellTableViewCell.h"

@implementation IngredienteCellTableViewCell




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];    
}


-(void)addRemove:(BOOL)selecionado
{
    if (selecionado)
    {
        [self.imgAddRemove setImage:[UIImage imageNamed:@"btnmore.png"]];
      
        if (self.delegate) {
            [self.delegate performSelectorInBackground:@selector(deleteIngrediente:) withObject:self.ingrediente];
        }
        
    }
    else
    {
        [self.imgAddRemove setImage:[UIImage imageNamed:@"btnless.png"]];
        if (self.delegate) {
            [self.delegate performSelectorInBackground:@selector(saveIngrediente:) withObject:self.ingrediente];
        }
    }
    
    self.onCart = selecionado;

}


- (IBAction)clickAddRemove:(id)sender
{
    self.ingrediente.selecionado = self.onCart;
    self.onCart = !self.onCart;
    [self addRemove:self.onCart];
}
@end
