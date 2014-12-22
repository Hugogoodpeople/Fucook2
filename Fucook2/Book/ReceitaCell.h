//
//  ReceitaCell.h
//  Fucook2
//
//  Created by Hugo Costa on 10/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectReceita.h"

@interface ReceitaCell : UITableViewCell

- (IBAction)clickCalendario:(id)sender;
- (IBAction)clickCarrinho:(id)sender;
- (IBAction)clickDelete:(id)sender;
- (IBAction)clickEdit:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonCalendario;
@property (weak, nonatomic) IBOutlet UIButton *buttonCarrinho;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;


@property (weak, nonatomic) IBOutlet UIView *viewMovel;
@property (weak, nonatomic) IBOutlet UILabel *labelTitulo;
@property (weak, nonatomic) IBOutlet UILabel *labelTempo;
@property (weak, nonatomic) IBOutlet UILabel *labelDificuldade;
@property (weak, nonatomic) IBOutlet UILabel *labelCategoria;
@property (weak, nonatomic) IBOutlet UIImageView *imagemReceita;

@property (weak, nonatomic) IBOutlet UIView *viewBotoes;


@property ObjectReceita * receita;

@property (nonatomic , assign) id delegate;
@property BOOL comprada;
@property BOOL pode;

@end
