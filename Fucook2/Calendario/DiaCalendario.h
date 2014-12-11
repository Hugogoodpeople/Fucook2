//
//  DiaCalendario.h
//  Fucook
//
//  Created by Hugo Costa on 13/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaCalendario : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lableDia;
@property (weak, nonatomic) IBOutlet UILabel *labelDiaSemana;
@property (weak, nonatomic) IBOutlet UIImageView *ImgSelected;

// para as refeições selecionadas
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;


@property BOOL img1Selected;
@property BOOL img2Selected;
@property BOOL img3Selected;
@property BOOL img4Selected;

@property NSString * diaSemana;
@property NSString * dia;


@end
