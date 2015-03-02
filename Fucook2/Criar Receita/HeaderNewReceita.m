//
//  HeaderNewReceita.m
//  Fucook
//
//  Created by Rundlr on 07/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "HeaderNewReceita.h"
#import "NIngredientes.h"

@interface HeaderNewReceita (){
    BOOL pickerCategory;
    BOOL pickerDificulty;
    BOOL pickerServings;
    BOOL pickerTime;
    NSArray *_pickerDataPrep;
    NSArray *_pickerDataCat;
    NSArray *_pickerDataDifi;
    
     NIngredientes * ingre;
}

@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic) UIImagePickerController *imagePickerController;


@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;


@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;

@end

@implementation HeaderNewReceita

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.capturedImages = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    
    _pickerDataPrep =  @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"10",
                         @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",
                         @"21", @"22", @"23", @"24", @"25",@"Set timer", @"26", @"27", @"28", @"29", @"30",
                         @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40",
                         @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50",
                         @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59", @"60",
                         @"75", @"90", @"105", @"120", @"150", @"180", @"240", @"300", @"360"
                         ];
    _pickerDataCat = @[@"Breakfast", @"Lunch", @"Dinner",@"Dessert"];
    _pickerDataDifi = @[@"Easy", @"Medium", @"Hard"];
    
    [self.pickerPrep selectRow:26 inComponent:0 animated:NO];
    
    self.textName.delegate=self;
    
    
    [self addCloseToTextView:self.textName];
    
}

-(void)addCloseToTextView:(UITextField *)textView
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
    [self.textName resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        if (self.delegate) {
            [self.delegate performSelector:@selector(scrollToPositionTop)];
            [self foiAlterado];
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btFoto:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Choose from library",
                            @"Take photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
    
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1:
        {
            switch (buttonIndex)
            {
                case 0:
                    NSLog(@"library");
                    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    break;
                case 1:
                    NSLog(@"photo");
                    //[self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
                    //if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
                    //}
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.img.isAnimating)
    {
        [self.img stopAnimating];
    }
    
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
   // [imagePickerController setShowsCameraControls:YES];
    [imagePickerController setAllowsEditing:YES];
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        //imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        /*
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
         */
         [imagePickerController setShowsCameraControls:YES];
    }
    
    self.imagePickerController = imagePickerController;
    [self.delegate presentViewController:imagePickerController animated:YES completion:nil];
    [self foiAlterado];
    
   
}

-(void)naoTemFoto
{
    self.viewPrimeiraVez.alpha      = 1;
    self.buttonFotoJaExiste.alpha   = 0;
}

- (void)temFoto
{
    /*
     self.viewPrimeiraVez.alpha      = 0;
     self.buttonFotoJaExiste.alpha   = 1;
     */
    
    /*
     [UIView animateWithDuration:0.5 animations:^{
     [self.viewPrimeiraVez setFrame:self.buttonFotoJaExiste.frame];
     self.labelAddFoto.alpha = 0;
     }];
     */
    
    self.labelAddFoto.alpha = 0;
    
    [UIView animateWithDuration: 1.5
                          delay: 0.5
         usingSpringWithDamping: 0.5
          initialSpringVelocity: 0.4
                        options: 0
                     animations: ^{
                         [self.viewPrimeiraVez setFrame:self.buttonFotoJaExiste.frame];
                         [self.viewPrimeiraVez setAlpha:0.75f];
                     } completion:^(BOOL finished) {
                     }];
    
}



#pragma mark - Toolbar actions

- (IBAction)done:(id)sender
{
    // Dismiss the camera.
    if ([self.cameraTimer isValid])
    {
        [self.cameraTimer invalidate];
    }
    [self finishAndUpdate];
}


- (IBAction)takePhoto:(id)sender
{
    [self.imagePickerController takePicture];
}


- (IBAction)delayedTakePhoto:(id)sender
{
    // These controls can't be used until the photo has been taken
    self.doneButton.enabled = NO;
    self.takePictureButton.enabled = NO;
    
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:5.0];
    NSTimer *cameraTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0 target:self selector:@selector(timedPhotoFire:) userInfo:nil repeats:NO];
    
    [[NSRunLoop mainRunLoop] addTimer:cameraTimer forMode:NSDefaultRunLoopMode];
    self.cameraTimer = cameraTimer;
}


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


- (IBAction)stopTakingPicturesAtIntervals:(id)sender
{
    // Stop and reset the timer.
    [self.cameraTimer invalidate];
    self.cameraTimer = nil;
    
    [self finishAndUpdate];
}


- (void)finishAndUpdate
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            [self.img setImage:[self.capturedImages objectAtIndex:0]];
            [self temFoto];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.img.animationImages = self.capturedImages;
            self.img.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.img.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.img startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }
    
    self.imagePickerController = nil;
}


#pragma mark - Timer

// Called by the timer to take a picture.
- (void)timedPhotoFire:(NSTimer *)timer
{
    [self.imagePickerController takePicture];
}


#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *image =   [info objectForKey:UIImagePickerControllerEditedImage];
   
    
    [self.capturedImages addObject:image];
    
    if ([self.cameraTimer isValid])
    {
        return;
    }
    
    [self finishAndUpdate];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)btCategory:(id)sender {
    if(pickerServings==1){[self btServings:self];}
    if(pickerDificulty==1){[self btDificulty:self];}
    if(pickerTime==1){[self btPretime:self];}
    if(pickerCategory){
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewPickerCategory setFrame:CGRectMake(0,  self.viewName.frame.origin.y+self.viewName.frame.size.height, self.viewPickerCategory.frame.size.width,self.viewPickerCategory.frame.size.height)];
            [self.viewServings setFrame:CGRectMake(0,  self.viewCategory.frame.origin.y+self.viewCategory   .frame.size.height, self.viewServings.frame.size.width,self.viewServings.frame.size.height)];
            [self.viewDificulty setFrame:CGRectMake(0,  self.viewServings.frame.origin.y+self.viewServings.frame.size.height, self.viewDificulty.frame.size.width,self.viewDificulty.frame.size.height)];
            //[self.viewPickerServings setFrame:CGRectMake(0,  self.viewServings.frame.origin.y+self.viewServings.frame.size.height, self.viewPickerServings.frame.size.width,self.viewPickerServings.frame.size.height)];
            //[self.viewPickerDificulty setFrame:CGRectMake(0,  self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height, self.viewPickerDificulty.frame.size.width,self.viewPickerDificulty.frame.size.height)];
            NSNumber *num = [NSNumber numberWithFloat:(self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
            NSNumber *tamPicker = [NSNumber numberWithFloat:(self.pickerCate.frame.size.height)];
            if (self.delegate) {
                [self.delegate performSelector:@selector(animarIngre:outro:) withObject:num withObject:tamPicker];
            }
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
            
        }];
        pickerCategory=0;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewPickerCategory setFrame:CGRectMake(0,  self.viewCategory.frame.origin.y+self.viewCategory.frame.size.height, self.viewPickerCategory.frame.size.width,self.viewPickerCategory.frame.size.height)];
            [self.viewServings setFrame:CGRectMake(0,  self.viewPickerCategory.frame.origin.y+self.viewPickerCategory.frame.size.height, self.viewServings.frame.size.width,self.viewServings.frame.size.height)];
            [self.viewDificulty setFrame:CGRectMake(0,  self.viewServings.frame.origin.y+self.viewServings.frame.size.height, self.viewDificulty.frame.size.width,self.viewDificulty.frame.size.height)];
            //[self.viewPickerServings setFrame:CGRectMake(0,  self.viewServings.frame.origin.y+self.viewServings.frame.size.height, self.viewPickerServings.frame.size.width,self.viewPickerServings.frame.size.height)];
            //[self.viewPickerDificulty setFrame:CGRectMake(0,  self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height, self.viewPickerDificulty.frame.size.width,self.viewPickerDificulty.frame.size.height)];
            NSNumber *num = [NSNumber numberWithFloat:(self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
            NSNumber *tamPicker = [NSNumber numberWithFloat:(self.pickerCate.frame.size.height)];
            if (self.delegate) {
                [self.delegate performSelector:@selector(animarIngre:outro:) withObject:num withObject:tamPicker];
            }
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
            
        }];
        pickerCategory=1;
    }

    if (self.delegate) {
        [self.delegate performSelector:@selector(scrollToPosition:) withObject:self.viewPickerCategory];
    }
    
    [self foiAlterado];
    [self setUpCategorias];
    
}

- (IBAction)btDificulty:(id)sender {
    if(pickerCategory==1){[self btCategory:self];}
    if(pickerServings==1){[self btServings:self];}
    if(pickerTime==1){[self btPretime:self];}
    if(pickerDificulty){
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewPickerDificulty setFrame:CGRectMake(0,  self.viewPre.frame.origin.y+self.viewPre.frame.size.height, self.viewPickerDificulty.frame.size.width,self.viewPickerDificulty.frame.size.height)];
            NSNumber *num = [NSNumber numberWithFloat:(self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
            NSNumber *tamPicker = [NSNumber numberWithFloat:(self.pickerDifi.frame.size.height)];
            if (self.delegate) {
                [self.delegate performSelector:@selector(animarIngre:outro:) withObject:num withObject:tamPicker ];
            }
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
        }];
        pickerDificulty=0;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewPickerDificulty setFrame:CGRectMake(0,  self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height, self.viewPickerDificulty.frame.size.width,self.viewPickerDificulty.frame.size.height)];
            NSNumber *num = [NSNumber numberWithFloat:(self.viewPickerDificulty.frame.origin.y+self.viewPickerDificulty.frame.size.height)];
            NSNumber *tamPicker = [NSNumber numberWithFloat:(self.viewPickerDificulty.frame.size.height)];
            if (self.delegate) {
                [self.delegate performSelector:@selector(animarIngre:outro:) withObject:num withObject:tamPicker];
            }
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.viewPickerDificulty.frame.origin.y+self.viewPickerDificulty.frame.size.height)];
        }];
        pickerDificulty=1;
    }

    if (self.delegate) {
        [self.delegate performSelector:@selector(scrollToPosition:) withObject:self.viewPickerDificulty];
    }
    
    [self foiAlterado];
}

- (IBAction)btServings:(id)sender {
    if(pickerCategory==1){[self btCategory:self];}
    if(pickerDificulty==1){[self btDificulty:self];}
    if(pickerTime==1){[self btPretime:self];}
    if(pickerServings){
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewPickerServings setFrame:CGRectMake(0,  self.viewAddD.frame.origin.y+self.viewAddD.frame.size.height, self.viewPickerServings.frame.size.width,self.viewPickerServings.frame.size.height)];
            [self.viewDificulty setFrame:CGRectMake(0,  self.viewServings.frame.origin.y+self.viewServings.frame.size.height, self.viewDificulty.frame.size.width,self.viewDificulty.frame.size.height)];
            [self.viewPickerDificulty setFrame:CGRectMake(0,  self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height, self.viewPickerDificulty.frame.size.width,self.viewPickerDificulty.frame.size.height)];
            NSNumber *num = [NSNumber numberWithFloat:(self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
             NSNumber *tamPicker = [NSNumber numberWithFloat:(self.pickerServi.frame.size.height)];
            if (self.delegate) {
                [self.delegate performSelector:@selector(animarIngre:outro:) withObject:num withObject:tamPicker];
            }
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
        }];
        pickerServings=0;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewPickerServings setFrame:CGRectMake(0,  self.viewServings.frame.origin.y+self.viewServings.frame.size.height, self.viewPickerServings.frame.size.width,self.viewPickerServings.frame.size.height)];
            [self.viewDificulty setFrame:CGRectMake(0,  self.viewPickerServings.frame.origin.y+self.viewPickerServings.frame.size.height, self.viewDificulty.frame.size.width,self.viewDificulty.frame.size.height)];
            [self.viewPickerDificulty setFrame:CGRectMake(0,  self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height, self.viewPickerDificulty.frame.size.width,self.viewPickerDificulty.frame.size.height)];
            NSNumber *num = [NSNumber numberWithFloat:(self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
            NSNumber *tamPicker = [NSNumber numberWithFloat:(self.pickerServi.frame.size.height)];
            if (self.delegate) {
                [self.delegate performSelector:@selector(animarIngre:outro:) withObject:num withObject:tamPicker];
            }
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
        }];
        pickerServings=1;
    }

    if (self.delegate) {
        [self.delegate performSelector:@selector(scrollToPosition:) withObject:self.viewPickerServings];
    }
    
    [self foiAlterado];
}

- (IBAction)btPretime:(id)sender {
    if(pickerCategory==1){[self btCategory:self];}
    if(pickerDificulty==1){[self btDificulty:self];}
    if(pickerServings==1){[self btDoneServ:self];}
    
    if(pickerTime){
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewPickerPrepa setFrame:CGRectMake(0,  self.viewChoose.frame.origin.y+self.viewChoose.frame.size.height, self.viewPickerPrepa.frame.size.width,self.viewPickerPrepa.frame.size.height)];
            [self.viewCategory setFrame:CGRectMake(0,  self.viewPre.frame.origin.y+self.viewPre.frame.size.height, self.viewCategory.frame.size.width,self.viewCategory.frame.size.height)];
            [self.viewServings setFrame:CGRectMake(0,  self.viewCategory.frame.origin.y+self.viewCategory.frame.size.height, self.viewServings.frame.size.width,self.viewServings.frame.size.height)];
            [self.viewDificulty setFrame:CGRectMake(0,  self.viewServings.frame.origin.y+self.viewServings.frame.size.height, self.viewDificulty.frame.size.width,self.viewDificulty.frame.size.height)];
            //[self.viewPickerCategory setFrame:CGRectMake(0,  self.viewCategory.frame.origin.y+self.viewCategory.frame.size.height, self.viewPickerCategory.frame.size.width,self.viewPickerCategory.frame.size.height)];
            //[self.viewPickerServings setFrame:CGRectMake(0,  self.viewServings.frame.origin.y+self.viewServings.frame.size.height, self.viewPickerServings.frame.size.width,self.viewPickerServings.frame.size.height)];
            //[self.viewPickerDificulty setFrame:CGRectMake(0,  self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height, self.viewPickerDificulty.frame.size.width,self.viewPickerDificulty.frame.size.height)];
            
            NSNumber *num = [NSNumber numberWithFloat:(self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
            NSNumber *tamPicker = [NSNumber numberWithFloat:(self.pickerPrep.frame.size.height)];
            if (self.delegate) {
                [self.delegate performSelector:@selector(animarIngre:outro:) withObject:num withObject:tamPicker];
            }
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
        }];
        pickerTime=0;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.viewPickerPrepa setFrame:CGRectMake(0,  self.viewPre.frame.origin.y+self.viewPre.frame.size.height, self.viewPickerPrepa.frame.size.width,self.viewPickerPrepa.frame.size.height)];
            [self.viewCategory setFrame:CGRectMake(0, self.viewPickerPrepa.frame.origin.y+self.viewPickerPrepa.frame.size.height, self.viewCategory.frame.size.width,self.viewCategory.frame.size.height)];
            [self.viewServings setFrame:CGRectMake(0, self.viewCategory.frame.origin.y+self.viewCategory.frame.size.height, self.viewServings.frame.size.width,self.viewServings.frame.size.height)];
            [self.viewDificulty setFrame:CGRectMake(0, self.viewServings.frame.origin.y+self.viewServings.frame.size.height, self.viewDificulty.frame.size.width,self.viewDificulty.frame.size.height)];
            //[self.viewPickerCategory setFrame:CGRectMake(0,  self.viewCategory.frame.origin.y+self.viewCategory.frame.size.height, self.viewPickerCategory.frame.size.width,self.viewPickerCategory.frame.size.height)];
            //[self.viewPickerServings setFrame:CGRectMake(0,  self.viewServings.frame.origin.y+self.viewServings.frame.size.height, self.viewPickerServings.frame.size.width,self.viewPickerServings.frame.size.height)];
            //[self.viewPickerDificulty setFrame:CGRectMake(0,  self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height, self.viewPickerDificulty.frame.size.width,self.viewPickerDificulty.frame.size.height)];
            NSNumber *num = [NSNumber numberWithFloat:(self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
            NSNumber *tamPicker = [NSNumber numberWithFloat:(self.pickerPrep.frame.size.height)];
            if (self.delegate) {
                [self.delegate performSelector:@selector(animarIngre:outro:) withObject:num withObject:tamPicker];
            }
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.viewDificulty.frame.origin.y+self.viewDificulty.frame.size.height)];
            
        }];
        pickerTime=1;
    }

    if (self.delegate) {
        [self.delegate performSelector:@selector(scrollToPosition:) withObject:self.viewPickerPrepa];
    }

    [self foiAlterado];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger number;
    if(pickerView.tag==1){
        number = _pickerDataPrep.count;
    }else if(pickerView.tag==2){
        number = _pickerDataCat.count;
    }else if(pickerView.tag==3){
        number = 25;
    }else if(pickerView.tag==4){
        number = _pickerDataDifi.count;
    }
    return number;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *baseString;
    if(pickerView.tag==1){
        baseString = [NSString stringWithFormat:@"%@ min", _pickerDataPrep[row]];
    }else if(pickerView.tag==2){
        baseString = _pickerDataCat[row];
    }else if(pickerView.tag==3){
        baseString = [NSString stringWithFormat:@"%ld Servings",(long)row+1];
    }else if(pickerView.tag==4){
        baseString = _pickerDataDifi[row];
    }
    return baseString;
}

- (IBAction)btDonePre:(id)sender {
    long a = [self.pickerPrep selectedRowInComponent:0];
    self.labelPre.text = [NSString stringWithFormat:@"%@ min",[_pickerDataPrep objectAtIndex:a]];
    [self btPretime:self];
}

- (IBAction)btDoneCate:(id)sender {
    long b = [self.pickerCate selectedRowInComponent:0];
    self.labelCat.text = [_pickerDataCat objectAtIndex:b];
    [self btCategory:self];
}

- (IBAction)btDoneServ:(id)sender {
    self.labelServ.text = [NSString stringWithFormat:@"%ld",(long)[self.pickerServi selectedRowInComponent:0] + 1];
    [self btServings:self];
}

- (IBAction)btDoneDifi:(id)sender {
    long d = [self.pickerDifi selectedRowInComponent:0];
    self.labelDif.text = [_pickerDataDifi objectAtIndex:d];
    [self btDificulty:self];
}

-(void)foiAlterado
{
    if (self.delegate)
    {
        [self.delegate performSelector:@selector(setfoiAlterado)];
    }
}

- (IBAction)clickphoto:(id)sender
{
    [self btFoto:nil];
}


- (IBAction)clickCat1:(id)sender
{
    //self.labelCat.text = [NSString stringWithFormat:@"Breakfast"];
    if ([self preencherCategoria:@"Breakfast "])
    {
        self.imgCat1.image = [UIImage imageNamed:@"icoremove"];
    }else
    {
        self.imgCat1.image = [UIImage imageNamed:@"icoadd"];
    }
}

- (IBAction)clickCat2:(id)sender
{
    //self.labelCat.text = [NSString stringWithFormat:@"Lunch"];
     if ([self preencherCategoria:@"Lunch "])
    {
        self.imgCat2.image = [UIImage imageNamed:@"icoremove"];
    }else
    {
        self.imgCat2.image = [UIImage imageNamed:@"icoadd"];
    }
}

- (IBAction)clickCat3:(id)sender
{
    //self.labelCat.text = [NSString stringWithFormat:@"Dinner"];
    if([self preencherCategoria:@"Dinner "])
    {
        self.imgCat3.image = [UIImage imageNamed:@"icoremove"];
    }else
    {
        self.imgCat3.image = [UIImage imageNamed:@"icoadd"];
    }
}

- (IBAction)clickCat4:(id)sender
{
    //self.labelCat.text = [NSString stringWithFormat:@"Dessert"];
    if([self preencherCategoria:@"Dessert "])
    {
        self.imgCat4.image = [UIImage imageNamed:@"icoremove"];
    }else
    {
        self.imgCat4.image = [UIImage imageNamed:@"icoadd"];
    }
}

-(void)setUpCategorias
{
    if ([self.labelCat.text rangeOfString:@"Breakfast"].length != 0)
    {
         self.imgCat1.image = [UIImage imageNamed:@"icoremove"];
    }
    if ([self.labelCat.text rangeOfString:@"Lunch"].length != 0)
    {
        self.imgCat2.image = [UIImage imageNamed:@"icoremove"];
    }
    if ([self.labelCat.text rangeOfString:@"Dinner"].length != 0)
    {
        self.imgCat3.image = [UIImage imageNamed:@"icoremove"];
    }
    if ([self.labelCat.text rangeOfString:@"Dessert"].length != 0)
    {
        self.imgCat4.image = [UIImage imageNamed:@"icoremove"];
    }
}

-(bool)preencherCategoria:(NSString *)categoria
{
    bool adicionado = NO;
    
    // tenho que verificar se a label já tem este valor e se sim tenho de remover, senao tenho de adicionar
    if ([self.labelCat.text rangeOfString:categoria].length != 0)
    {
        self.labelCat.text = [self.labelCat.text stringByReplacingOccurrencesOfString:categoria withString:@""];
    }
    else
    {
        self.labelCat.text = [NSString stringWithFormat:@"%@%@", categoria , self.labelCat.text];
        adicionado = YES;
    }
    
    return adicionado;
}

@end