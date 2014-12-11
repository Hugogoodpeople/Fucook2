//
//  CellIngrediente.m
//  Fucook
//
//  Created by Hugo Costa on 19/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "CellIngrediente.h"

@interface CellIngrediente ()
@property (nonatomic) BOOL constraintsSetup;
@end

@implementation CellIngrediente


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.viewDados = [IngreTwoOptionsController new];
        self.viewDados.delegate = self;
        
        [self.topContentView setFrame:self.frame];
        
        [self.topContentView addSubview:self.viewDados.view];
        
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickRemover:(id)sender {
    if (self.delegateHugo) {
        [self.delegateHugo performSelector:@selector(removerIngrediente:) withObject:self.ingrediente];
    }
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    if (!self.constraintsSetup) {
        
        self.constraintsSetup = YES;
    }
    
    ObjectIngrediente * ingre = (ObjectIngrediente *)self.ingrediente;
    
    self.viewDados.labelNome.text = [NSString stringWithFormat:@"%@%@%@ %@", ingre.quantidade, ingre.quantidadeDecimal , ingre.unidade,ingre.nome];
}

@end
