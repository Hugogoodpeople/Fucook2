//
//  CellEtapa.m
//  Fucook
//
//  Created by Hugo Costa on 02/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "CellEtapa.h"
#import "ObjectDirections.h"

@interface CellEtapa ()
@property (nonatomic) BOOL constraintsSetup;
@end

@implementation CellEtapa


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





- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.viewDados = [EtapaTwoOptionsController new];
        self.viewDados.delegate = self;
        
        [self.topContentView setFrame:self.frame];
        
        [self.topContentView addSubview:self.viewDados.view];
        
        
    }
    return self;
}



- (void)updateConstraints
{
    [super updateConstraints];
    
    if (!self.constraintsSetup) {
        
        self.constraintsSetup = YES;
    }
    
    ObjectDirections * etapa = (ObjectDirections *)self.ingrediente;
    
    self.viewDados.labelNome.text = etapa.descricao;
    if (etapa.tempoMinutos == 0) {
        self.viewDados.labelDesc.text = @"Set timer";
    }
    else
    {
        self.viewDados.labelDesc.text = [NSString stringWithFormat:@"%d MIN" ,etapa.tempoMinutos];
    }
    
}

@end
