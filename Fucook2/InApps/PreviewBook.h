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


- (IBAction)clickAddRecipe:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewVazia;

@end
