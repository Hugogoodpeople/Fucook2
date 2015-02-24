//
//  NewBook.m
//  Fucook
//
//  Created by Rundlr on 07/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "NewBook.h"
#import "ObjectLivro.h"
#import "UIImage+fixOrientation.h"


@interface NewBook ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolBar;
@property (nonatomic) UIImagePickerController *imagePickerController;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *takePictureButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) NSMutableArray *capturedImages;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITextField *txt1;
@property (weak, nonatomic) IBOutlet UITextField *txt2;

@end

@implementation NewBook


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /* bt search*/
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 60, 32)];
    [button addTarget:self action:@selector(Adicionarlivro) forControlEvents:UIControlEventTouchUpInside];
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

    self.navigationItem.title = @"NEW BOOK";
    self.capturedImages = [[NSMutableArray alloc] init];
    
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    self.txt1.delegate=self;
    self.txt2.delegate=self;
    self.txt1.tag=1;
    self.txt2.tag=2;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 10, 20)];
    self.txt2.leftView = paddingView;

    // tenho de preencher tudo caso já tenha cenas para serem carregadas
    
    if (self.managedObject)
    {
    
        [self.viewPrimeiraVez setFrame:self.buttonFotoJaExiste.frame];
        self.labelAddFoto.alpha = 0;
        
        NSLog(@"************************************ Livro ************************************");
        NSLog(@"titulo: %@", [self.managedObject valueForKey:@"titulo"]);
        NSLog(@"descrição: %@", [self.managedObject valueForKey:@"descricao"]);
    
        ObjectLivro * livro = [ObjectLivro new];
    
        // para mais tarde poder apagar
        livro.managedObject = self.managedObject;
    
    
        livro.titulo =[self.managedObject valueForKey:@"titulo"];
        livro.descricao =[self.managedObject valueForKey:@"descricao"];
    
    
        NSManagedObject * imagem = [self.managedObject valueForKey:@"contem_imagem"];
        livro.managedImagem = imagem;
    
        self.txt1.text = livro.titulo;
        self.txt2.text = livro.descricao;
    
        [self.imageView setImage:[[UIImage imageWithData:[livro.managedImagem valueForKey:@"imagem"]] fixOrientation]];
    }
    else
    {
        [self naoTemFoto];
    }
    
    
    [self addCloseToTextView:self.txt1];
    [self addCloseToTextView:self.txt2];
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
    [self.txt1 resignFirstResponder];
    [self.txt2 resignFirstResponder];
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

- (IBAction)back:(id)sender {
    // Receita *objYourViewController = [[Receita alloc] initWithNibName:@"Receita" bundle:nil];
    [self.navigationController popViewControllerAnimated:YES];
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

-(void)Adicionarlivro
{
    // é aqui que tenho de ir gravar as cenas que acabei de escrever
    
    AppDelegate* appDelegate = [AppDelegate sharedAppDelegate];
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    
    if(!self.managedObject)
    {
        
        NSManagedObject *Livro = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Livros"
                                  inManagedObjectContext:context];
        [Livro setValue:self.txt1.text forKey:@"titulo"];
        [Livro setValue:self.txt2.text forKey:@"descricao"];
    
        NSManagedObject *Imagem = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"Imagens"
                                   inManagedObjectContext:context];
    
        NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.15);
        [Imagem setValue:imageData forKey:@"imagem"];
        [Livro setValue:Imagem forKey:@"contem_imagem"];
        [Livro setValue:[NSNumber numberWithBool:YES] forKey:@"comprado"];
    
        [self listarTodosLivros];
    
    }else
    {
        
        NSManagedObject *Livro = self.managedObject;
        
        [Livro setValue:self.txt1.text forKey:@"titulo"];
        [Livro setValue:self.txt2.text forKey:@"descricao"];
        
        NSManagedObject *Imagem = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"Imagens"
                                   inManagedObjectContext:context];
        
        
        NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.15);
        [Imagem setValue:imageData forKey:@"imagem"];
        [Livro setValue:Imagem forKey:@"contem_imagem"];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }

    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)listarTodosLivros
{
    
    NSManagedObjectContext *context = [AppDelegate sharedAppDelegate].managedObjectContext;
    
    // para ver se deu algum erro ao inserir
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
    // para ir buscar os dados prestendidos a base de dados
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Livros" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *pedido in fetchedObjects)
    {
        
        
        NSLog(@"************************************ Pedido ************************************");
        NSLog(@"titulo: %@", [pedido valueForKey:@"titulo"]);
        NSLog(@"descrição: %@", [pedido valueForKey:@"descricao"]);

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag==1){
        CGPoint scrollPoint = CGPointMake(0.0, 50);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }else if(textField.tag==2){
        CGPoint scrollPoint = CGPointMake(0.0, 140);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    CGPoint scrollPoint = CGPointMake(0.0, -50);
    
    [self.scrollView setContentOffset:scrollPoint animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (IBAction)btcamera:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Choose from library",
                            @"Take photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    NSLog(@"library");
                    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    break;
                case 1:
                    NSLog(@"photo");
                     [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
                    //if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                       //[self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
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

- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.imageView.isAnimating)
    {
        [self.imageView stopAnimating];
    }
    
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    
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
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
    
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
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
            [self temFoto];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.imageView.animationImages = self.capturedImages;
            self.imageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.imageView startAnimating];
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
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)clickFoto:(id)sender
{
    [self btcamera:nil];
}
@end
