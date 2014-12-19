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
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           /*[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],*/
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithTextArea)],
                           nil];
    [numberToolbar sizeToFit];
    self.textviewNote.inputAccessoryView = numberToolbar;
    
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
                                            self.view.frame.size.height - 320)];
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.viewMovel setFrame:frameInicial];
    }];
}
@end
