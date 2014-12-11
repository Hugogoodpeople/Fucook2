//
//  DirectionsHeaderViewController.h
//  Fucook
//
//  Created by Hugo Costa on 12/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientesHeader : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lablelPasso;
@property (weak, nonatomic) IBOutlet UITextField *labelTempo;
@property (weak, nonatomic) IBOutlet UILabel *labelTitulo;

@property NSString * passo;
@property NSString * tempo;



@end
