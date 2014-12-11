//
//  NotesViewer.h
//  Fucook2
//
//  Created by Hugo Costa on 11/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesViewer : UIViewController

@property ( nonatomic , assign ) id delegate;

@property (weak, nonatomic) IBOutlet UILabel *labelNote;
@property (weak, nonatomic) IBOutlet UITextView *textviewNote;
@property (weak, nonatomic) IBOutlet UIImageView *imageArredondar;

- (IBAction)clickClose:(id)sender;

@property NSString * notas;
@property (weak, nonatomic) IBOutlet UIView *viewEscura;

@end
