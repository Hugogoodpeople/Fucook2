//
//  PesquisaReceitaCell.h
//  Fucook
//
//  Created by Hugo Costa on 14/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectReceita.h"

@interface PesquisaReceitaCell : UITableViewCell



- (IBAction)clickCalendario:(id)sender;
- (IBAction)clickCarrinho:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *viewMovel;
@property (weak, nonatomic) IBOutlet UILabel *labelTitulo;
@property (weak, nonatomic) IBOutlet UILabel *labelTempo;
@property (weak, nonatomic) IBOutlet UILabel *labelDificuldade;
@property (weak, nonatomic) IBOutlet UILabel *labelCategoria;
@property (weak, nonatomic) IBOutlet UIImageView *imagemReceita;

@property ObjectReceita * receita;

@property (nonatomic , assign) id delegate;

@end
