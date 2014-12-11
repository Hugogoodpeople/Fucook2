//
//  ReceitaVisualizar.h
//  Fucook2
//
//  Created by Hugo Costa on 10/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectReceita.h"

@interface ReceitaVisualizar : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tabela;

@property NSMutableArray * items;
@property NSMutableArray * itemsDirections;
@property ObjectReceita * receita;
@property (weak, nonatomic) IBOutlet UIView *containerHeader;

@end
