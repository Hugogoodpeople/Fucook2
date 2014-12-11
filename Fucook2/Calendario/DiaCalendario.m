//
//  DiaCalendario.m
//  Fucook
//
//  Created by Hugo Costa on 13/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "DiaCalendario.h"

@interface DiaCalendario ()

@end

@implementation DiaCalendario

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.labelDiaSemana.text = self.diaSemana;
    self.lableDia.text = self.dia;
    
    
    // tambem tenho de mudar aqui os backgrounds

    
    // aqui tenho de verificar qual foi a refeição selecionada
    if (self.img1Selected)
    {
        [self.img1 setBackgroundColor:[UIColor blackColor]];
    }
     if(self.img2Selected)
    {
        [self.img2 setBackgroundColor:[UIColor blackColor]];
    }
     if(self.img3Selected)
    {
        [self.img3 setBackgroundColor:[UIColor blackColor]];
    }
     if(self.img4Selected)
    {
        [self.img4 setBackgroundColor:[UIColor blackColor]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ok aqui tenho de ir verificar se tenho ou nao algo reservado neste dia
// ou tenho algum lado onde possa fazer isto melhor



@end
