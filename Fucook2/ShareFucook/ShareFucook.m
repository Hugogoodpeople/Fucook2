//
//  ShareFucook.m
//  Fucook2
//
//  Created by Hugo Costa on 23/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "ShareFucook.h"
#import <Social/Social.h>
#import <Pinterest/Pinterest.h>

@interface ShareFucook ()
{
    UIDocumentInteractionController *docController;
    Pinterest*  _pinterest;
}

@end

@implementation ShareFucook

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCancel:)];
    
    [self.viewEscura addGestureRecognizer:tapGestureRecognizer];
    
    self.viewButtons.layer.cornerRadius = 5;
    self.viewButtons.clipsToBounds = YES;
    
    self.viewCancel.layer.cornerRadius = 5;
    self.viewCancel.clipsToBounds = YES;
    
    NSData * data           = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.livro.urlImagem_partilha]];
    self.livro.imagem = [UIImage imageWithData:data];
    
    if (!self.isInInApps) {
        [self.viewBotoesSecundarios setAlpha:1];
        self.livro = [ObjectLivro new];
        self.livro.titulo = self.receita.nome;
        NSData * data           = [self.receita.managedImagem valueForKey:@"imagem"];
        
        self.livro.imagem = [UIImage imageWithData:data];
        
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
        
        if(![[UIApplication sharedApplication] canOpenURL:instagramURL])
        {
            [self.viewBotoesSecundarios setAlpha:0];
        }
        
    }
    else
    {
        [self.viewBotoesSecundarios setAlpha:0];
    }
    
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

- (IBAction)clickFacebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        // Device is able to send a Twitter message
    }
    
    SLComposeViewController *composeController = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [composeController setInitialText:@"Just found this great book"];
    [composeController addImage:self.livro.imagem];
    [composeController addURL: [NSURL URLWithString:
                                @"http://www.fucook.com"]];
    
    
    
    [self presentViewController:composeController animated:YES completion:nil];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
    {
        if (result == SLComposeViewControllerResultCancelled)
        {
            NSLog(@"cancele");
            [self dismissViewControllerAnimated:NO completion:nil];
        } else
            
        {
            NSLog(@"post to Facebook done");
            // tenho de adicionar o livro a lista de livros do utilizador
            if (self.delegate) {
                [self.delegate performSelector:@selector(comprarLivro:) withObject:self.livro];
            }
            
            [self close];
        }
        
    };
    composeController.completionHandler = myBlock;
}

- (IBAction)clickTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        // Device is able to send a Twitter message
    }
    
    SLComposeViewController *composeController = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [composeController setInitialText:@"Just found this great book"];
    [composeController addImage:self.livro.imagem];
    [composeController addURL: [NSURL URLWithString:
                                @"http://www.fucook.com"]];
    
    
    
    [self presentViewController:composeController animated:YES completion:nil];
    
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
    {
        if (result == SLComposeViewControllerResultCancelled)
        {
            NSLog(@"cancele");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else
            
        {
            NSLog(@"post to twitter done");
            // tenho de adicionar o livro a lista de livros do utilizador
            if (self.delegate) {
                [self.delegate performSelector:@selector(comprarLivro:) withObject:self.livro];
            }
            [self close];
        }
        
    };
    composeController.completionHandler = myBlock;
}

- (IBAction)clickInstagram:(id)sender
{
    //Remember Image must be larger than 612x612 size if not resize it.
    
    // tenho de verificar se a imagem tem no minimo 612 de altura e largura senao tenho de fazer resize
    if(self.livro.imagem.size.height < 612 || self.livro.imagem.size.height < 612)
    {
        self.livro.imagem = [self imageWithImage:self.livro.imagem scaledToSize:CGSizeMake(612, 612)];
    }
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        
        NSString *documentDirectory=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *saveImagePath=[documentDirectory stringByAppendingPathComponent:@"Image.igo"];
        NSData *imageData=UIImagePNGRepresentation(self.livro.imagem);
        [imageData writeToFile:saveImagePath atomically:YES];
        
        docController=[[UIDocumentInteractionController alloc]init];

       

        NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
        {
            docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:saveImagePath]];
            docController.UTI = @"com.instagram.image";
            
            docController.annotation=[NSDictionary dictionaryWithObjectsAndKeys:@"Image Taken via @fucook.com",@"InstagramCaption", nil];
            docController.delegate = self;
     
            // este funciona
             [docController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
            
        }
        
      
        
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"warning" message:@"App not found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)clickPinterest:(id)sender
{
    _pinterest = [[Pinterest alloc] initWithClientId:@"1442094" urlSchemeSuffix:@"prod"];
    
    NSURL * stringUrl = [NSURL URLWithString:self.livro.urlImagem];
    NSURL * StringURLFuccok = [NSURL URLWithString:@"www.fucook.com"];
    
    [_pinterest createPinWithImageURL:stringUrl
                            sourceURL:StringURLFuccok
                          description:self.livro.titulo];
}



- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)clickCancel:(id)sender
{
    [self close];
}

-(void)close
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.viewEscura setAlpha:0];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
}
@end
