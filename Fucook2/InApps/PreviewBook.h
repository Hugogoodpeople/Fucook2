//
//  PreviewBook.h
//  Fucook2
//
//  Created by Hugo Costa on 17/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectLivro.h"

@interface PreviewBook : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *tabela;

@property ObjectLivro * livro;

@property NSMutableArray * items;
@property NSMutableArray * imagens;

@property (nonatomic, assign) id delegate;


- (IBAction)clickAddRecipe:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewVazia;

// a compra dos livros pelas inApps agora vai ser feito por aqui
// não foi pensado para ser assim por isso alterações vao ser feitas para acomodar tal ateração
@property NSArray * products;

@property NSManagedObjectContext * context;

@end
