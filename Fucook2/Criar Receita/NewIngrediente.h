//
//  NewIngrediente.h
//  Fucook
//
//  Created by Rundlr on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectIngrediente.h"

@interface NewIngrediente : UIViewController <UITextFieldDelegate , UIPickerViewDataSource, UIPickerViewDelegate>

@property ObjectIngrediente * ingrediente;

@property (nonatomic ,assign) id delegate;

@property (weak, nonatomic) IBOutlet UIView *viewQuantity;


@property (weak, nonatomic) IBOutlet UIView *viewLabel1;
@property (weak, nonatomic) IBOutlet UIView *viewLabel3;
@property (weak, nonatomic) IBOutlet UIView *viewLabel2;

//- (IBAction)btQuant:(id)sender;
- (IBAction)clickQuantidade:(id)sender;
- (IBAction)clickUnidade:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textQuant;
@property (weak, nonatomic) IBOutlet UITextField *textUnity;


@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerQuant;
- (IBAction)btDone:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewBlock;


@end
