//
//  NewNotes.m
//  Fucook
//
//  Created by Rundlr on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "NewNotes.h"

@interface NewNotes ()

@end

@implementation NewNotes

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 60, 32)];
    [button addTarget:self action:@selector(AddNota) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"btnsave2"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    //self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-4];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,anotherButton,nil];

    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 10, 40)];
    [buttonback addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft1"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;
    
    self.navigationItem.title = @"Notes";
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleTap];
    
    
    self.textNote.text = self.textoNota;
    
    [self scrollTextViewToBottom:self.textNote];
    
    [self addCloseToTextView:self.textNote];
    
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
    [self.textNote resignFirstResponder];
}


-(void)scrollTextViewToBottom:(UITextView *)textView {
    if(textView.text.length > 0 ) {
        NSRange bottom = NSMakeRange(textView.text.length -1, 1);
        [textView scrollRangeToVisible:bottom];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)AddNota
{
    if (self.delegate)
    {
        //[self.delegate performSelectorInBackground:@selector(adicionarNota:) withObject:self.textNote.text];
        [self.delegate performSelector:@selector(adicionarNota:) withObject:self.textNote.text afterDelay:0.5];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleSingleTap
{
    [self.textNote resignFirstResponder];
    //CGPoint scrollPoint = CGPointMake(0, 0);
    //[self.viewNote setContentOffset:scrollPoint animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
