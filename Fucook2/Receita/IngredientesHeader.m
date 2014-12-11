//
//  DirectionsHeaderViewController.m
//  Fucook
//
//  Created by Hugo Costa on 12/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "IngredientesHeader.h"

@interface IngredientesHeader ()

@end

@implementation IngredientesHeader

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lablelPasso.text = self.passo;
    self.labelTempo.text = self.tempo;
    
    [self adicionarToolBar];
    
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
    if (self.labelTempo.text.length == 0)
    {
        self.labelTempo.text = @"Set timer";
    }else
    {
        self.labelTempo.text = [NSString stringWithFormat:@"%@ MIN", self.labelTempo.text ];
        [self setNotification:nil];
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


// para as notificações locais tenho de ir buscar a label do tempo
- (IBAction)setNotification:(UIButton *)sender
{
    
    NSLog(@"clicar %@", self.labelTempo.text);
    // tenho de verificar se está escrito Set timer
    if ([self.labelTempo.text isEqualToString:@"Set timer"])
    {
        [self.labelTempo becomeFirstResponder];
        [self.labelTempo setText:@""];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alarm" message:@"You want to create an alarm?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
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
        }
    }
}


-(void)chamarNotificacao
{
    
    NSString *stringWithoutMin = [self.labelTempo.text stringByReplacingOccurrencesOfString:@"MIN" withString:@""];
    
    int tempo = [stringWithoutMin intValue];
    
    NSDate *matchDateCD = [NSDate new];
    
    // aqui tenho de meter o tempo para o alarme
    NSDate *addTime = [matchDateCD dateByAddingTimeInterval:(tempo*60)]; // compiler will precompute this to be 5400, but indicating the breakdown is clearer
    
    NSLog(@"ás %@", addTime.description );
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = addTime;
    localNotification.alertBody = [NSString stringWithFormat:@"Alert Fired at %@", addTime];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    // para adicionar o cenas do numero na aplicação
    // localNotification.applicationIconBadgeNumber = 5;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}


@end
