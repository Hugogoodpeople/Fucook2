//
//  PreviewBook.m
//  Fucook2
//
//  Created by Hugo Costa on 17/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "PreviewBook.h"
#import "ReceitaCell.h"
#import "UIImageView+WebCache.h"

@interface PreviewBook ()

@end

@implementation PreviewBook

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 10, 40)];
    [buttonback addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft1"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;
    
    
    [self.tabela setContentInset:UIEdgeInsetsMake(70, 0, 4, 0)];
    
}

-(void)actualizarTudo
{
    [self preencherTabela];
}



-(void)viewWillAppear:(BOOL)animated
{
    [self actualizarTudo];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)preencherTabela
{
    self.items = self.livro.receitas;
}





#pragma table

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"ReceitaCell";
    
    ReceitaCell *cell = (ReceitaCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReceitaCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ObjectReceita * rec = [self.items objectAtIndex:indexPath.row];
    
    cell.labelTitulo.text = rec.nome;
    cell.labelTempo.text = rec.tempo;
    cell.labelCategoria.text = rec.categoria;
    cell.labelDificuldade.text = rec.dificuldade;
    cell.pode = YES;
    cell.receita = rec;
    // tenho de calcular com base no que esta no header
    
    //cell.labelQtd.text = [self calcularValor:indexPath];
    //cell.delegate = self;
    
    [cell.imagemReceita sd_setImageWithURL:[NSURL URLWithString:rec.urlImagem ] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        rec.imagem = image;
    }];
    
       
    
    
    return cell;
    
}

@end

