//
//  CellEtapa.h
//  Fucook
//
//  Created by Hugo Costa on 02/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectIngrediente.h"
#import "JASwipeCell.h"
#import "EtapaTwoOptionsController.h"

@interface CellEtapa : JASwipeCell
@property (weak, nonatomic) IBOutlet UILabel *labelNome;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;

- (IBAction)clickRemover:(id)sender;

@property NSObject * ingrediente;
@property (nonatomic, assign) id delegateHugo;

@property EtapaTwoOptionsController * viewDados;

@end
