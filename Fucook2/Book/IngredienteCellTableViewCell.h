//
//  IngredienteCellTableViewCell.h
//  Fucook
//
//  Created by Hugo Costa on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectIngrediente.h"

@interface IngredienteCellTableViewCell : UITableViewCell

@property ObjectIngrediente * ingrediente;

@property (nonatomic ,assign) id delegate;
//@property (weak, nonatomic) IBOutlet UILabel *labelQtd;
@property (weak, nonatomic) IBOutlet UILabel *LabelTitulo;
- (IBAction)clickAddRemove:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgAddRemove;

@property BOOL onCart;
-(void)addRemove:(BOOL)selecionado;

@property (weak, nonatomic) IBOutlet UIView *viewAddRemove;
@property (weak, nonatomic) IBOutlet UILabel *labelAddRemove;


@property UIImage * blur;
@property BOOL isFromInApps;

@end
