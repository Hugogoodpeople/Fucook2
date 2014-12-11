//
//  NewReceita.h
//  Fucook
//
//  Created by Rundlr on 07/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectLivro.h"
#import "ObjectReceita.h"

@interface NewReceita : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollNewReceita;

@property ObjectLivro * livro;
@property ObjectReceita * receita;

@end
