//
//  PesquisaReceitas.h
//  Fucook
//
//  Created by Hugo Costa on 14/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PesquisaReceitas : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searcBar;

@property (weak, nonatomic) IBOutlet UITableView *tabela;


@end
