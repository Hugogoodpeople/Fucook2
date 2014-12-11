//
//  HeaderNewReceita.h
//  Fucook
//
//  Created by Rundlr on 07/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderNewReceita : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>
@property (nonatomic,assign) id delegate;
- (IBAction)btFoto:(id)sender;

- (IBAction)btCategory:(id)sender;
- (IBAction)btDificulty:(id)sender;
- (IBAction)btServings:(id)sender;
- (IBAction)btPretime:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewPre;
@property (weak, nonatomic) IBOutlet UIView *viewDificulty;
@property (weak, nonatomic) IBOutlet UIView *viewServings;
@property (weak, nonatomic) IBOutlet UIView *viewCategory;

@property (weak, nonatomic) IBOutlet UIView *viewPickerDificulty;
@property (weak, nonatomic) IBOutlet UIView *viewPickerServings;
@property (weak, nonatomic) IBOutlet UIView *viewPickerCategory;
@property (weak, nonatomic) IBOutlet UIView *viewPickerPrepa;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerPrep;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCate;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerServi;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerDifi;

- (IBAction)btDonePre:(id)sender;
- (IBAction)btDoneCate:(id)sender;
- (IBAction)btDoneServ:(id)sender;
- (IBAction)btDoneDifi:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *labelPre;
@property (weak, nonatomic) IBOutlet UILabel *labelCat;
@property (weak, nonatomic) IBOutlet UILabel *labelServ;
@property (weak, nonatomic) IBOutlet UILabel *labelDif;

@property (weak, nonatomic) IBOutlet UITextField *textName;

@property (weak, nonatomic) IBOutlet UIView *viewChoose;
@property (weak, nonatomic) IBOutlet UIView *viewName;

@property (weak, nonatomic) IBOutlet UIView *viewAddD;

@property (weak, nonatomic) IBOutlet UIImageView *img;


@end