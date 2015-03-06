//
//  Calendario.m
//  Fucook
//
//  Created by Hugo Costa on 12/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "Calendario.h"
#import "ObjectCalendario.h"


@interface Calendario ()
{
    NSManagedObject * tempAgenda;
}

@property NSMutableArray * items;
@property NSMutableArray * datas;
@property VRGCalendarView *calendar;
@property NSDate * tempDate;

@end



@implementation Calendario
@synthesize calendar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.delegate) {
        self.title = @"Rescheduled";
    }
    else
    {
        self.title = @"Daily Menu";
    }
    
    
    
    calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    [self.container addSubview:calendar];
    
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 10, 40)];
    [buttonback addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft1"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;
    
    [self setUp];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUp
{
    _items = [NSMutableArray new];
    _datas = [NSMutableArray new];
    
    NSManagedObjectContext *context = [AppDelegate sharedAppDelegate].managedObjectContext;
    
    // para ir buscar os dados prestendidos a base de dados
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Agenda" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *pedido in fetchedObjects)
    {
        
        ObjectCalendario * dia = [ObjectCalendario new];
        
        dia.data = [pedido valueForKey:@"data"];
        dia.categoria = [pedido valueForKey:@"categoria"];
        dia.managedObject = pedido;
        
        
        if([pedido valueForKey:@"tem_receita"])
        {
            [_items addObject:dia];
            [_datas addObject:dia.data];
        }
    }
    
    // resumindo muito eu tenho de verificar se o mes
    NSMutableArray * dias = [NSMutableArray new];
    for (NSDate * data in _datas) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:data];
        //if([components month] == month)
        {
            [dias addObject:[NSNumber numberWithInteger:[components day]]];
        }
    }
    
    [calendar markDates:dias];

}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    /*
    // resumindo muito eu tenho de verificar se o mes
    NSMutableArray * dias = [NSMutableArray new];
    for (NSDate * data in _datas) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:data];
        if([components month] == month)
        {
            [dias addObject:[NSNumber numberWithInteger:[components day]]];
        }
    }
    
    [calendarView markDates:dias];
     */
}


-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSLog(@"Selected date = %@",date);
    // aqui tenho de adicionar a receita a uma data
    
    self.tempDate = date;
    
    // tenho de verificar se na data actualmente escolhida ja tem alguma coisa agendada
    // se sim tenho de remover da actionsheet os que já estão escolhidos para essa data
    
    NSMutableArray * categorias = [[NSMutableArray alloc] initWithArray: @[@"Breakfast",@"Lunch",@"Dinner",@"Dessert"]];
    
    /*
     for (int i = 0 ; i< _datas.count ; i++)
     {
     NSDate * data = [_datas objectAtIndex:i];
     if(data == date)
     {
     ObjectCalendario * cal = [_items objectAtIndex:i];
     NSLog(@"categoria ja existente %@", cal.categoria);
     [categorias removeObject:cal.categoria];
     
     
     
     }
     }
     */
    /// esta parte funciona perfeitamente removendo as refeições já selecionadas
    
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            nil,
                            nil];
    // ObjC Fast Enumeration
    for (NSString *title in categorias) {
        [popup addButtonWithTitle:title];
    }
    
    if (categorias.count == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Upss" message:@"All meals filled" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag)
    {
        case 1:
        {
            
            NSString * selecionado = [popup buttonTitleAtIndex:buttonIndex];
            
            if (![selecionado isEqualToString:@"Cancel"]) {
                NSLog(@"refeição selecionada: %@", selecionado);
                [self adacionarAoCalendario:selecionado];
            }
            
        }
        default:
            break;
    }
}

-(void)adacionarAoCalendario:(NSString *)categoria
{
    BOOL jaTinhaAgendada = false;
    NSManagedObject *agenda;
    for (int i = 0 ; i< _datas.count ; i++)
    {
        NSDate * data = [_datas objectAtIndex:i];
        if([data compare: self.tempDate] == NSOrderedSame)
        {
            ObjectCalendario * cal = [_items objectAtIndex:i];
            
            if ([cal.categoria isEqualToString:categoria])
            {
                agenda = cal.managedObject;
                jaTinhaAgendada = YES;
            }
        }
    }
    
    NSManagedObjectContext *context = [AppDelegate sharedAppDelegate].managedObjectContext;
    
    if (!agenda) {
        
        if (self.calendario) {
            [context deleteObject:self.calendario];
        }
        
        agenda = [NSEntityDescription insertNewObjectForEntityForName:@"Agenda" inManagedObjectContext:context];
        
    }
    
    tempAgenda = agenda;
    
    [agenda setValue:self.tempDate forKey:@"data"];
    [agenda setValue:categoria forKey:@"categoria"];
    
    
    // tenho de colocar uma alertview para avisar que estou a alterar alguma coisa
    if (jaTinhaAgendada) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"There is already a recipe scheduled for this meal for this date.\nDo you want to replace it?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alert.tag = 1;
        [alert show];
        
        
    }
    else
    {
        
        NSMutableArray * arrayAgenda = [NSMutableArray new];
        
        NSSet * agendamentos = [self.receita valueForKey:@"esta_agendada"];
        
        for (NSManagedObject * ag in agendamentos)
        {
            [arrayAgenda addObject:ag];
        }
        
        [self.receita setValue:[NSSet setWithArray:[[NSArray alloc] initWithArray:arrayAgenda]] forKey:@"esta_agendada"];
        
        [agenda setValue:self.receita forKey:@"tem_receita"];
        
        
        NSError *error = nil;
        if (![context save:&error])
        {
            NSLog(@"error core data! %@ %@", error, [error localizedDescription]);
            return;
        }
        else
        {
            NSLog(@"Gravado com sucesso");
        }
        
        if (self.delegate)
        {
            [self.delegate performSelector:@selector(recarregarTudo:) withObject:self.tempDate];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1)
        {
            NSError *error = nil;
            NSManagedObjectContext *context = [AppDelegate sharedAppDelegate].managedObjectContext;
            
            NSMutableArray * arrayAgenda = [NSMutableArray new];
            
            NSSet * agendamentos = [self.receita valueForKey:@"esta_agendada"];
            
            for (NSManagedObject * ag in agendamentos)
            {
                [arrayAgenda addObject:ag];
            }
            
            [self.receita setValue:[NSSet setWithArray:[[NSArray alloc] initWithArray:arrayAgenda]] forKey:@"esta_agendada"];
            
            [tempAgenda setValue:self.receita forKey:@"tem_receita"];
            
            if (![context save:&error])
            {
                NSLog(@"error core data! %@ %@", error, [error localizedDescription]);
                return;
            }
            else
            {
                NSLog(@"Gravado com sucesso");
            }
            if (self.delegate) {
                [self.delegate performSelector:@selector(recarregarTudo) ];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


@end
