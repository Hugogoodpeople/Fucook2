//
//  HeaderIngrediente.m
//  Fucook
//
//  Created by Hugo Costa on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "HeaderIngrediente.h"

@interface HeaderIngrediente ()

@property BOOL servingdOpen;

@end

@implementation HeaderIngrediente

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imagemReceita.image    = self.imagem;
    self.labelTempo.text        = self.tempo;
    self.labelDificuldade.text  = self.dificuldade;
    self.labelNome.text         = self.nome;
    self.labelNumberServings.text = self.servings;
    self.labelCategoria.text    = self.categoria;
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

- (IBAction)clickCart:(id)sender {
    if (self.delegate) {
        [self.delegate performSelector:@selector(callCart) withObject:nil];
    }
    
    
}

-(void)clickservings
{
    
    if (self.servingdOpen)
        [UIView animateWithDuration:0.5 animations:^{
            //[self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.pickerServings.frame.size.height)];
            [self.pickerServings setFrame:CGRectMake(0, 175, self.view.frame.size.width, 162)];
        }];
    else
        [UIView animateWithDuration:0.5 animations:^{
            //[self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height + self.pickerServings.frame.size.height)];
            [self.pickerServings setFrame:CGRectMake(0, 300, self.view.frame.size.width, 162)];

        }];
    
    /*
    if (self.delegate)
    {
        [self.delegate performSelector:@selector(callPikerServings) withObject:nil afterDelay:0.0];
    }
    */
     
    self.servingdOpen = !self.servingdOpen;
}

- (IBAction)clickCalendar:(id)sender
{
    if (self.delegate) {
        [self.delegate performSelector:@selector(calendarioReceita) withObject:nil];
    }
}

- (IBAction)clickNotas:(id)sender
{
    if (self.delegate) {
        [self.delegate performSelector:@selector(abrirNotes)];
    }
}

- (IBAction)clickTimer:(id)sender
{
    NSLog(@"clicar %@", self.labelTempo.text);
    // tenho de verificar se está escrito Set timer
    if ([self.tempo isEqualToString:@"Set timer"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set timer" message:@"This recipe doesn't have a preparation time set" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set timer" message:[NSString stringWithFormat: @"Do you want to set an alarm to %@ min. from now?", self.tempo ] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = 1;
        
        [alert show];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld Servings",(long)row+1];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 25;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   // self.labelNumberServings.text =  [NSString stringWithFormat:@"%ld",(long)row];
}

- (IBAction)DoneServings:(id)sender
{
    self.labelNumberServings.text = [NSString stringWithFormat:@"%ld",(long)[self.pickerServings selectedRowInComponent:0]+1];
    [self clckServings:self];
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
    NSString *stringWithoutMin = [self.tempo stringByReplacingOccurrencesOfString:@"min" withString:@""];
    
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
    
    //self.labelTempo.text = @"Set timer";
}


@end
