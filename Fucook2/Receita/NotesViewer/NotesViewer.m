//
//  NotesViewer.m
//  Fucook2
//
//  Created by Hugo Costa on 11/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "NotesViewer.h"

@interface NotesViewer ()
{
    CGRect frameInicial;
}

@end

@implementation NotesViewer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textviewNote.text = self.notas;
  
    self.imageArredondar.layer.cornerRadius = 10;
    self.imageArredondar.clipsToBounds = YES;
    
    
    // para o apply button
    
    
    [self addCloseToTextView:self.textviewNote];
    
    
}

-(void)addCloseToTextView:(UITextView *)textView
{
    UIView* numberToolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width -15 -44, 15.5, 44, 44)];
    [button addTarget:self action:@selector(doneWithTextArea) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"btntecladodown"] forState:UIControlStateNormal];
    
    [button setClipsToBounds:NO];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // finally do the magic
    float topInset = 14.0f;
    anotherButton.imageInsets = UIEdgeInsetsMake(topInset, 0.0f, -topInset, 0.0f);
    
    [numberToolbar setBackgroundColor:[UIColor clearColor]];
    
    
    [numberToolbar addSubview:button];
    
    //[numberToolbar sizeToFit];
    textView.inputAccessoryView = numberToolbar;

}

-(void)doneWithTextArea
{
    [self.textviewNote resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickClose:(id)sender
{
     [UIView animateWithDuration:0.2 animations:^{
         self.viewEscura.alpha = 0;
     } completion:^(BOOL finished) {
         [self dismissViewControllerAnimated:YES completion:^{
             if (self.delegate) {
                 [self.delegate performSelector:@selector(actualizarNota:) withObject:self.textviewNote.text];
             }
         }];
     }];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    frameInicial = self.viewMovel.frame;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.viewMovel setFrame:CGRectMake(self.viewMovel.frame.origin.x,
                                            self.viewMovel.frame.origin.y,
                                            self.viewMovel.frame.size.width,
                                            self.view.frame.size.height - 290)];
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.viewMovel setFrame:frameInicial];
    }];
}
@end
