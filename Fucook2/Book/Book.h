//
//  Books.h
//  Fucook
//
//  Created by Hugo Costa on 03/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ObjectLivro.h"

@interface Book : UIViewController <UITableViewDelegate >

@property (weak, nonatomic) IBOutlet UITableView *tabela;

@property ObjectLivro * livro;

@property NSMutableArray * items;
@property NSMutableArray * imagens;


- (IBAction)clickAddRecipe:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewVazia;


@end