//
//  CellIngrediente.h
//  Fucook
//
//  Created by Hugo Costa on 19/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectIngrediente.h"
#import "JASwipeCell.h"

#import "IngreTwoOptionsController.h"


@interface CellIngrediente : JASwipeCell

@property IngreTwoOptionsController * viewDados;



@property (weak, nonatomic) IBOutlet UILabel *labelNome;
//@property (weak, nonatomic) IBOutlet UILabel *labelDesc;

- (IBAction)clickRemover:(id)sender;

@property NSObject * ingrediente;
@property (nonatomic, assign) id delegateHugo;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ;
- (void)updateConstraints;



@end
