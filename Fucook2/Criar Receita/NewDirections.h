//
//  NewDirections.h
//  Fucook
//
//  Created by Rundlr on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectDirections.h"

@interface NewDirections : UIViewController <UITextViewDelegate>

@property (nonatomic, assign) id delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollDir;


- (IBAction)btAbrir:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;


@property (weak, nonatomic) IBOutlet UIView *viewDown;
@property (weak, nonatomic) IBOutlet UIView *viewPicker;
@property (weak, nonatomic) IBOutlet UIView *viewLabel1;
@property (weak, nonatomic) IBOutlet UIView *viewLabel2;

@property (weak, nonatomic) IBOutlet UIView *viewText;

- (IBAction)btDoneTime:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textDesc;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property ObjectDirections * directions;

@end
