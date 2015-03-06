//
//  DirectionsCell.m
//  Fucook
//
//  Created by Hugo Costa on 12/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "DirectionsCell.h"
#import "UIImage+ImageEffects.h"

@implementation DirectionsCell




-(UIImage *)blurredSnapshot:(UIView *)view
{
    
    // Now apply the blur effect using Apple's UIImageEffect category
    //UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
    UIImage *blurredSnapshotImage = [[self imageWithView:self.contentView] applyBlurWithRadius:2 tintColor:[UIColor clearColor] saturationDeltaFactor:1 maskImage:nil];
    
    // Be nice and clean your mess up
    UIGraphicsEndImageContext();
    
    return blurredSnapshotImage;
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


- (void)awakeFromNib {
    // Initialization code
    [self adicionarToolBar];
    
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    if (!self.blur && self.isFromInApps) {
        // Configure the view for the selected state
        UIImageView * imagem = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        imagem.image = [self blurredSnapshot:self.contentView];
        
        self.blur = imagem;
        // para remover os toques nos botoes atras
        self.blur.userInteractionEnabled = YES;
        [self.contentView addSubview:self.blur];
    }
    else
    {
        [self.blur setFrame:self.contentView.bounds];
    }
    

    
}

-(void)adicionarToolBar
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           /*[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],*/
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.labelTempo.inputAccessoryView = numberToolbar;
}

-(void)doneWithNumberPad
{
    [self.labelTempo resignFirstResponder];
    if (self.labelTempo.text.length == 0) {
        self.labelTempo.text = @"Set timer";
    }else
    {
        self.labelTempo.text = [NSString stringWithFormat:@"%@ min", self.labelTempo.text];
        [self setNotification:nil];
    }
}

// para as notificações locais tenho de ir buscar a label do tempo
- (IBAction)setNotification:(UIButton *)sender
{
    NSLog(@"clicar %@", self.labelTempo.text);
    // tenho de verificar se está escrito Set timer
    if ([self.labelTempo.text isEqualToString:@"Set timer"])
    {
        self.tempo = self.labelTempo.text;
        [self.labelTempo becomeFirstResponder];
        [self.labelTempo setText:@""];
    }
    else
    {
        self.tempo = self.labelTempo.text;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set timer" message:[NSString stringWithFormat: @"Do you want to set an alarm to %@. from now?", self.labelTempo.text ] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = 1;
        
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            [self chamarNotificacao];
        }
        else
        {
            NSLog(@"User cancelou notificação");
            self.labelTempo.text = self.tempo;
        }
    }
}


-(void)chamarNotificacao
{
    
    NSString *stringWithoutMin = [self.labelTempo.text stringByReplacingOccurrencesOfString:@"min" withString:@""];
    
    int tempo = [stringWithoutMin intValue];
    
    NSDate *matchDateCD = [NSDate new];
    
    // aqui tenho de meter o tempo para o alarme
    NSDate *addTime = [matchDateCD dateByAddingTimeInterval:(tempo*60)]; // compiler will precompute this to be 5400, but indicating the breakdown is clearer
    
    NSLog(@"ás %@", addTime.description );
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = addTime;
    localNotification.alertBody = [NSString stringWithFormat:@"Times up for %@ %@ direction",self.nomeReceita, self.labelPasso.text];
    localNotification.soundName = @"clock_alarm.mp3";
    // para adicionar o cenas do numero na aplicação
    // localNotification.applicationIconBadgeNumber = 5;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
 
    
    //self.labelTempo.text = @"Set timer";
}

@end
