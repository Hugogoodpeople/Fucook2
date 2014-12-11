//
//  NotesViewer.m
//  Fucook2
//
//  Created by Hugo Costa on 11/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "NotesViewer.h"

@interface NotesViewer ()

@end

@implementation NotesViewer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textviewNote.text = self.notas;
  
    self.imageArredondar.layer.cornerRadius = 10;
    self.imageArredondar.clipsToBounds = YES;
    
    
    
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
         [self dismissViewControllerAnimated:YES completion:^{}];
     }];
    
    
}
@end
