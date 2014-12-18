//
//  HomeCell.h
//  Fucook2
//
//  Created by Hugo Costa on 09/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectLivro.h"

@interface HomeCell : UITableViewCell


@property ObjectLivro * livro;
@property (nonatomic, assign) id delegate;

@property (weak, nonatomic) IBOutlet UIView *viewEdit;
@property (weak, nonatomic) IBOutlet UIView *viewDelete;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;
@property (weak, nonatomic) IBOutlet UIButton *ButtonDelete;
- (IBAction)clickEdit:(id)sender;
- (IBAction)clickDelete:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewMovel;

@property (weak, nonatomic) IBOutlet UILabel *labelTitulo;
@property (weak, nonatomic) IBOutlet UIImageView *imagemLivro;
@property (weak, nonatomic) IBOutlet UILabel *labelDescricao;
@property (weak, nonatomic) IBOutlet UILabel *labelNumeroReceitas;
@property (weak, nonatomic) IBOutlet UILabel *labelRecipes;

@property (weak, nonatomic) IBOutlet UIImageView *imgBreakfast;
@property (weak, nonatomic) IBOutlet UIImageView *imgLunch;
@property (weak, nonatomic) IBOutlet UIImageView *imgDinner;
@property (weak, nonatomic) IBOutlet UIImageView *imgDessert;

@property (weak, nonatomic) IBOutlet UIView *viewDescricao;

@property (weak, nonatomic) IBOutlet UILabel *labelCategoria;
@property (weak, nonatomic) IBOutlet UIView *viewCategoria;


@end
