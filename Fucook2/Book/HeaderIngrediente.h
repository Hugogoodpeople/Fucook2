//
//  HeaderIngrediente.h
//  Fucook
//
//  Created by Hugo Costa on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderIngrediente : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic , assign) id delegate;
- (IBAction)clickCart:(id)sender;
- (IBAction)clckServings:(id)sender;
- (IBAction)clickCalendar:(id)sender;
- (IBAction)clickNotas:(id)sender;
- (IBAction)clickTimer:(id)sender;



@property (weak, nonatomic) IBOutlet UIPickerView *pickerServings;

@property (weak, nonatomic) IBOutlet UILabel *labelNumberServings;

- (IBAction)DoneServings:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *addedRemovedView;
@property (weak, nonatomic) IBOutlet UILabel *labelAllitensAddedRemoved;

@property (weak, nonatomic) IBOutlet UIImageView *imagemReceita;
@property (weak, nonatomic) IBOutlet UILabel *labelNome;

@property UIImage * imagem;
@property NSString * tempo;
@property NSString * dificuldade;
@property NSString * nome;
@property NSString * servings;
@property NSString * categoria;

@property (weak, nonatomic) IBOutlet UILabel *labelTempo;
@property (weak, nonatomic) IBOutlet UILabel *labelDificuldade;
@property (weak, nonatomic) IBOutlet UILabel *labelCategoria;


@property (weak, nonatomic) IBOutlet UILabel *labelAddRemoveAll;


@end
