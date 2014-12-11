//
//  NewDirections.m
//  Fucook
//
//  Created by Rundlr on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "NewDirections.h"
#import "ObjectDirections.h"

@interface NewDirections (){
     BOOL PickerAberto;
    NSArray * tempos;
    
}

@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;

@end

@implementation NewDirections

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [button addTarget:self action:@selector(AdicionarDirections) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"btnsave2"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [buttonback addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft2"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;
    
    self.navigationItem.title = @"Directions";
    
    [self.scrollDir setContentSize:CGSizeMake(self.view.frame.size.width, self.viewDown.frame.origin.y+self.viewDown.frame.size.height+5)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.capturedImages = [[NSMutableArray alloc] init];
    
    self.textDesc.delegate=self;
    self.textDesc.tag=1;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleTap];
    
    tempos = @[@"Set timer",@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"10",
               @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",
               @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30",
               @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40",
               @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50",
               @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59", @"60",
               @"75", @"90", @"105", @"120", @"150", @"180", @"240", @"300", @"360"
               ];


    if (self.directions)
    {
        self.textDesc.text = self.directions.descricao;
        if(self.directions.tempoMinutos != 0)
            self.labelTime.text = [NSString stringWithFormat:@"%d MIN", self.directions.tempoMinutos];
        else
            self.labelTime.text = @"Set time";
    }
    
}

-(void)AdicionarDirections
{
    ObjectDirections * direct = [ObjectDirections new];
    direct.descricao = self.textDesc.text;
    
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    direct.tempoMinutos = [[tempos objectAtIndex:row] intValue];
    
    
    if (self.directions) {
     
        if (self.delegate) {
            [self.delegate performSelector:@selector(actualizarEtapa::) withObject:self.directions withObject:direct];
        }
    }
    else{
    
        if (self.delegate) {
            [self.delegate performSelector:@selector(AdicionarDirections:) withObject:direct];
        }
    }
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if(PickerAberto==1){
        [self btAbrir:self];
    }
    /*
        CGPoint scrollPoint = CGPointMake(0, 300);
        [self.scrollDir setContentOffset:scrollPoint animated:YES];
     */
}


-(void)handleSingleTap
{
    [self.textDesc resignFirstResponder];
    CGPoint scrollPoint = CGPointMake(0, 0);    
    [self.scrollDir setContentOffset:scrollPoint animated:YES];
}




- (IBAction)btFoto:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Choose from library",
                            @"Take photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - Toolbar actions

- (IBAction)startTakingPicturesAtIntervals:(id)sender
{
    /*
     Start the timer to take a photo every 1.5 seconds.
     
     CAUTION: for the purpose of this sample, we will continue to take pictures indefinitely.
     Be aware we will run out of memory quickly.  You must decide the proper threshold number of photos allowed to take from the camera.
     One solution to avoid memory constraints is to save each taken photo to disk rather than keeping all of them in memory.
     In low memory situations sometimes our "didReceiveMemoryWarning" method will be called in which case we can recover some memory and keep the app running.
     */
    
    
    self.doneButton.enabled = NO;
    self.takePictureButton.enabled = NO;
    
    self.cameraTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timedPhotoFire:) userInfo:nil repeats:YES];
    [self.cameraTimer fire]; // Start taking pictures right away.
}






#pragma mark - Timer

// Called by the timer to take a picture.
- (void)timedPhotoFire:(NSTimer *)timer
{
    [self.imagePickerController takePicture];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}




-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // não precisa fazer nada aqui mas convem ter este metodo implementado
    
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return tempos.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString * tempo;
    if (row== 0) {
        tempo = [tempos objectAtIndex:row];
    }
    else
    {
        tempo = [NSString stringWithFormat:@"%@ min", [tempos objectAtIndex:row]];
    }
        
    
    return tempo;
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 2000;
}


- (IBAction)btAbrir:(id)sender {
    NSLog(@"%u",PickerAberto);
    if(PickerAberto){
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewDown setFrame:CGRectMake(0,  self.viewLabel1.frame.size.height+self.viewLabel2.frame.size.height+65, self.viewDown.frame.size.width,self.viewDown.frame.size.height)];
        }];
        [self.scrollDir setContentSize:CGSizeMake(self.view.frame.size.width, 680)];
        PickerAberto=0;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewDown setFrame:CGRectMake(0, self.viewLabel1.frame.size.height+self.viewLabel2.frame.size.height+self.viewPicker.frame.size.height+65, self.viewDown.frame.size.width,self.viewDown.frame.size.height)];
        }];
        [self.scrollDir setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
        PickerAberto=1;
    }
    
}
- (IBAction)btDoneTime:(id)sender {
    //long d = [self.pickerView selectedRowInComponent:0];
   //self.labelTime.text = [NSString stringWithFormat:@"%ld",(long)[self.pickerView selectedRowInComponent:0]+1];
    if([self.pickerView selectedRowInComponent:0] == 0)
    {
        self.labelTime.text = [NSString stringWithFormat:@"%@",  [tempos objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
    }
    else
    {
        self.labelTime.text = [NSString stringWithFormat:@"%@ min",  [tempos objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
    }
        
    [self btAbrir:self];
}
@end
