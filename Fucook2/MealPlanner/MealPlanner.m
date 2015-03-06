//
//  MealPlanner.m
//  Fucook
//
//  Created by Hugo Costa on 13/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "MealPlanner.h"
#import "DiaCalendario.h"
#import "MealPlanerTable.h"
#import "AppDelegate.h"
#import "ObjectCalendario.h"
#import "ObjectReceita.h"
#import "Calendario.h"
#import "ObjectIngrediente.h"
#import "ObjectLista.h"
#import "PesquisaReceitas.h"
#import "NewBook.h"
#import "Settings.h"
#import "ReceitaVisualizar.h"
#import "PesquisaVazio.h"

@interface MealPlanner ()
{
    NSMutableArray * arrayDias;
    NSMutableArray * arrayDatas;
    PesquisaVazio  * vazio;
    
    int indexSelected;
}

@property (nonatomic, strong) NSMutableArray *items;
@property MealPlanerTable * root;

@property UIView * itemAnterior;

@end

@implementation MealPlanner





- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [button addTarget:self action:@selector(clickSettings:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"btnsetting1"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    //self.navigationItem.leftBarButtonItem = anotherButton;
    
    /* bt add*/
    UIButton * buttonadd = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [buttonadd addTarget:self action:@selector(addbook) forControlEvents:UIControlEventTouchUpInside];
    [buttonadd setImage:[UIImage imageNamed:@"btnaddbook"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButtonadd = [[UIBarButtonItem alloc] initWithCustomView:buttonadd];
    
    UIButton * buttonSettings = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [buttonSettings addTarget:self action:@selector(Findreceita) forControlEvents:UIControlEventTouchUpInside];
    [buttonSettings setImage:[UIImage imageNamed:@"btnsearch"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButtonSettings = [[UIBarButtonItem alloc] initWithCustomView:buttonSettings];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: anotherButton,anotherButtonadd, anotherButtonSettings, nil]];
    
    //[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:anotherButtonadd, nil]];
    
    [self.toobar setFrame:CGRectMake(0, self.toobar.frame.origin.y -4, self.toobar.frame.size.width, 48)];
    
    // para remover a linha da tollbar
    [self.toobar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.toobar setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.97f]];
    [self.toobar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    
    vazio = [PesquisaVazio new];
    
    
    [vazio.view setFrame:CGRectMake(0, 0, self.container.frame.size.width, self.container.frame.size.height)];
    
    [vazio.labelTitulo setText:@"Add recipes to your calendar"];
    [vazio.labelDescricao setText:@"You don't have added any recipes for today."];
    [vazio.img setImage:[UIImage imageNamed:@"imgaddrecipe.png"]];
    
    //[self.container addSubview:vazio.view];
    
    [self recarregarTudo];

}

-(void)recarregarTudo
{
    self.navigationController.navigationBarHidden = YES;
    [self setUp];
    [self setUpCoreData];
    [self setUpCarrocel];
}

-(void)recarregarTudo:(NSDate *)date
{
    self.dataActual = date;
    self.navigationController.navigationBarHidden = YES;
    [self setUp];
    [self setUpCoreData];
    [self setUpCarrocel];
}



- (IBAction)clickHome:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)clickcarrinho:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:NO];
    if (self.delegate)
    {
        [self.delegate performSelector:@selector(clickCarrinho:) withObject:nil];
    }
}

- (IBAction)clickInApps:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:NO];
    if (self.delegate) {
        [self.delegate performSelector:@selector(clickInApps:) withObject:nil];
    }
}

- (IBAction)clickSettings:(id)sender
{
    [self presentViewController:[Settings new] animated:YES completion:^{}];
}

-(void)Findreceita
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:[PesquisaReceitas new] animated:YES];
}

-(void)addbook {
    NSLog(@"clicou add");
    
    NewBook *objYourViewController = [[NewBook alloc] initWithNibName:@"NewBook" bundle:nil];
    [self.navigationController pushViewController:objYourViewController animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    /*
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
    [self setUp];
    [self setUpCoreData];
    [self setUpCarrocel];
     */
}

-(void)setUp
{
    
    [self instanciateTable];
    
    /*
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [buttonback addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft2"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;
    */
    
}

-(void)instanciateTable
{
    if (self.root)
    {
        // [self.root.view removeFromSuperview];
    }
    else
    {
        self.root = [MealPlanerTable new];
        //[self.root.view setFrame:[[UIScreen mainScreen] bounds]];
        
        // tenho de verificar a data de hoje para meter as receitas
        
        
        [self.root.view setFrame:CGRectMake(0, 0, self.container.frame.size.width , self.container.frame.size.height)];
        
        self.root.view.backgroundColor = [UIColor clearColor];
        
        [self.container addSubview:self.root.view];
        self.root.delegate = self;
        
        // depois tenho de activar esta parte
        self.root.tableView.delegate = self;
        [self.root.tableView setContentInset:UIEdgeInsetsMake(0, 0, 48, 0)];
    }
}

-(void)verReceita:(ObjectReceita *) receita
{
    
    ReceitaVisualizar * recietas = [ReceitaVisualizar new];
    recietas.receita = receita;
    
    [self.navigationController pushViewController:recietas animated:YES];
    
    
}

-(void)setUpCoreData
{
    NSManagedObjectContext *context = [AppDelegate sharedAppDelegate].managedObjectContext;
    
    arrayDias = [NSMutableArray new];
    arrayDatas = [NSMutableArray new];
    
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
        dia.receitas = [NSMutableArray new];
        dia.data = [pedido valueForKey:@"data"];
        dia.categoria = [pedido valueForKey:@"categoria"];
        dia.managedObject = pedido;
        // dia.receita = [pedido valueForKey:@"contem_receitas"];
        
        NSManagedObject * receitaManaged = [pedido valueForKey:@"tem_receita"];
        NSLog(@"managed object %@", pedido.description);
        
        if (receitaManaged )
        {
            ObjectReceita * objR = [ObjectReceita new];
            [objR setTheManagedObject:receitaManaged];
            objR.categoriaAgendada = dia.categoria;
            
            [dia.receitas addObject:objR];
            objR.agendamento = dia.managedObject;
        }
        
        [arrayDias addObject:dia];
        [arrayDatas addObject:dia.data];
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpCarrocel
{
    //configure carousel
    _carousel.type = iCarouselTypeLinear;
    
    if (!self.dataActual)
    {
        self.dataActual = [NSDate new];
    }
    
    
    NSDateFormatter *dateFormatterMes = [[NSDateFormatter alloc] init];
    [dateFormatterMes setDateFormat:@"MMMM yyyy"];
    self.labelMes.text = [dateFormatterMes stringFromDate:self.dataActual];
    
    
    // para o primeiro dia do mes actual
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.dataActual];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comp];
    
    
    NSDate *today = self.dataActual; //Get a date object for today's date
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:today];
    
    
    
    self.items = [NSMutableArray array];
    for (int i = 0; i < days.length; i++)
    {
        [_items addObject:firstDayOfMonthDate];
        
        NSDate *addTime = [firstDayOfMonthDate dateByAddingTimeInterval:(24*60*60)];
        firstDayOfMonthDate = addTime;
    }
    
    
    [_carousel reloadData];
    
    
    NSDateFormatter *dateFormatterDia = [[NSDateFormatter alloc] init];
    [dateFormatterDia setDateFormat:@"dd"];
    
    int diaHoje ;
    //if (!indexSelected)
        diaHoje = [dateFormatterDia stringFromDate:self.dataActual].intValue;
    indexSelected = diaHoje;
    
    [_carousel scrollToItemAtIndex:diaHoje animated:false];
    [_carousel scrollToItemAtIndex:diaHoje-1 animated:false];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145 ;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    NSDateFormatter *dateFormatterSemana = [[NSDateFormatter alloc] init];
    [dateFormatterSemana setDateFormat:@"EEE"];
    //NSLog(@"dia semana %@", [dateFormatter stringFromDate:[self.items objectAtIndex:index]]);
    
    NSDateFormatter *dateFormatterMes = [[NSDateFormatter alloc] init];
    [dateFormatterMes setDateFormat:@"dd"];
    //NSLog(@"dia semana %@", [dateFormatter stringFromDate:[self.items objectAtIndex:index]]);
    
    NSString * diaSemana = [dateFormatterSemana stringFromDate:[self.items objectAtIndex:index]];
    NSString * diaMes = [dateFormatterMes stringFromDate:[self.items objectAtIndex:index]];
    
    DiaCalendario * dia = [DiaCalendario new];
    dia.diaSemana = [diaSemana uppercaseString];
    dia.dia = diaMes;
    
    dia.img1Selected = false;
    dia.img2Selected = false;
    dia.img3Selected = false;
    dia.img4Selected = false;
    
    // basta revificar se tenho algo agendado para o dia em questao
    // se sim entao tenho de mudar as cores das pintas nas celulas
    for (ObjectCalendario * cal in arrayDias)
    {
        NSString * diaString =[dateFormatterSemana stringFromDate:cal.data];
        NSString * MesString =[dateFormatterMes stringFromDate:cal.data];
        
        if ([diaString isEqualToString:diaSemana] && [MesString isEqualToString:diaMes])
        {
            // aqui tenho de verificar qual foi a refeição selecionada
            if ([cal.categoria isEqualToString:@"Breakfast"])
            {
                dia.img1Selected = true;
            }
            else if([cal.categoria isEqualToString:@"Lunch"])
            {
                dia.img2Selected = true;
            }
            else if([cal.categoria isEqualToString:@"Dinner"])
            {
                dia.img3Selected = true;
            }
            else if([cal.categoria isEqualToString:@"Dessert"])
            {
                dia.img4Selected = true;
            }
            
        }
    }
    return dia.view;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
   // NSLog(@"mudou indice %ld", (long)carousel.currentItemIndex);
    
    // tenho de actualizar a data aqui
    
    if (self.itemAnterior) {
        DiaCalendario * dia = [DiaCalendario new];
        dia.view =self.itemAnterior;
        
        dia.ImgSelected = (UIImageView *)[dia.view viewWithTag:1];
        [UIView animateWithDuration:0.2 animations:^{
            dia.ImgSelected.alpha = 0;
        }];
        
        // para as sombras programaticamente
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:dia.view.bounds];
        dia.view.layer.masksToBounds = NO;
        dia.view.layer.shadowColor = [UIColor blackColor].CGColor;
        dia.view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        dia.view.layer.shadowOpacity = 0.0f;
        dia.view.layer.shadowPath = shadowPath.CGPath;
        
    }
    
    // tenho de ir burcar a view actual e mudar algo para ficar diferente
    DiaCalendario * dia = [DiaCalendario new];
    dia.view =[carousel currentItemView];
    dia.ImgSelected = (UIImageView *)[dia.view viewWithTag:1];
    [UIView animateWithDuration:0.2 animations:^{
        dia.ImgSelected.alpha = 1;
        
    }];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:dia.view.bounds];
    dia.view.layer.masksToBounds = NO;
    dia.view.layer.shadowColor = [UIColor blackColor].CGColor;
    dia.view.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    dia.view.layer.shadowOpacity = 0.5f;
    dia.view.layer.shadowPath = shadowPath.CGPath;
    
    self.itemAnterior = dia.view;
    
    // tenho de executar este codigo numa thread
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
    dispatch_async(queue, ^{
        
        // codigo dentro da thread
        // aqui tenho de actualizar a view que tem as receitas vindas da BD
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.dataActual];
        [components setDay:carousel.currentItemIndex +1];
        
        NSDate * scrollDay = [calendar dateFromComponents:components];
        
        NSMutableArray * itensDias = [NSMutableArray new];
        
        for (ObjectCalendario * cal in arrayDias)
        {
            if ([cal.data compare:scrollDay] == NSOrderedSame)
            {
                // ok aqui tenho de dizer que a receita esta dentro do agendamento
                [itensDias addObjectsFromArray: cal.receitas];
            }
        }
        //[self instanciateTable];
        
        self.root.arrayOfItems = itensDias;
        [self.root actualizarImagens];
        
        
        
        //[self.root.tableView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // codigo a exutar na main thread
            [self.root.tableView reloadData];
            
            if (self.root.arrayOfItems.count == 0) {
                [self.container addSubview:vazio.view];
            }
            else
            {
                [vazio.view removeFromSuperview];
            }

        });
    });
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.0;
    }
    if (option == iCarouselOptionWrap) {
        return YES;
    }
    if (option == iCarouselOptionVisibleItems) {
        return 7;
    }
    return value;
}


- (IBAction)clickMesSeguinte:(id)sender
{
    NSDateFormatter *dateFormatterDia = [[NSDateFormatter alloc] init];
    [dateFormatterDia setDateFormat:@"dd"];
    NSString * diaMes = [dateFormatterDia stringFromDate:self.dataActual];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.dataActual];
    
    NSDateFormatter *dateFormatterMes = [[NSDateFormatter alloc] init];
    [dateFormatterMes setDateFormat:@"MM"];
    NSString * mesSeguinte = [dateFormatterMes stringFromDate:self.dataActual];
    
    
    [comp setMonth:mesSeguinte.intValue +1];
    [comp setDay:diaMes.intValue];
    
    NSRange days = [gregorian rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:[gregorian dateFromComponents:comp]];
    
    if (days.length < diaMes.intValue)
    {
        [comp setDay:days.length];
    }
    else
    {
        [comp setDay:diaMes.intValue];
    }
    
    self.dataActual = [gregorian dateFromComponents:comp];
    
    [self setUpCarrocel];
}

- (IBAction)clickMesAnterior:(id)sender
{
    NSDateFormatter *dateFormatterDia = [[NSDateFormatter alloc] init];
    [dateFormatterDia setDateFormat:@"dd"];
    NSString * diaMes = [dateFormatterDia stringFromDate:self.dataActual];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.dataActual];
    [comp setDay:diaMes.intValue];
    NSDateFormatter *dateFormatterMes = [[NSDateFormatter alloc] init];
    [dateFormatterMes setDateFormat:@"MM"];
    NSString * mesSeguinte = [dateFormatterMes stringFromDate:self.dataActual];
    
    [comp setMonth:mesSeguinte.intValue -1 ];
    
    
    //NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [gregorian rangeOfUnit:NSCalendarUnitDay
                           inUnit:NSCalendarUnitMonth
                          forDate:[gregorian dateFromComponents:comp]];
    
    if (days.length < diaMes.intValue)
    {
        [comp setDay:days.length];
    }
    else
    {
        [comp setDay:diaMes.intValue];
    }
    
    self.dataActual = [gregorian dateFromComponents:comp];
    
    [self setUpCarrocel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld", (long)indexPath.row);
    
    // tenho de ir buscar os valores a tabela para poder abrir o objecto correcto
    ObjectReceita * receita = [self.root.arrayOfItems objectAtIndex:indexPath.row];
    ReceitaVisualizar * recietas = [ReceitaVisualizar new];
    recietas.receita = receita;
    
    [self.navigationController pushViewController:recietas animated:YES];
}

-(void)apagarReceita:(ObjectReceita *)receita
{
    NSManagedObjectContext * context = [AppDelegate sharedAppDelegate].managedObjectContext;
    
    [context deleteObject:receita.agendamento];
    
    // aqui tenho de percorrer o agendamento que contem a receita... provavelmente nao preciso de receber a receita
    
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    else
    {
        NSLog(@"apagado agendamento com sucesso");
        
        [self setUpCoreData];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.dataActual];
        [components setDay:self.carousel.currentItemIndex +1];
        
        NSDate * scrollDay = [calendar dateFromComponents:components];
        
        NSMutableArray * itensDias = [NSMutableArray new];
        
        for (ObjectCalendario * cal in arrayDias) {
            if (cal.data == scrollDay) {
                // ok aqui tenho de dizer que a receita esta dentro do agendamento
                [itensDias addObjectsFromArray: cal.receitas];
            }
        }
        
        [self instanciateTable];
        
        self.root.arrayOfItems = itensDias;
        [self.root actualizarImagens];
        
        [_carousel reloadItemAtIndex:_carousel.currentItemIndex animated:NO];
        [self carouselCurrentItemIndexDidChange:_carousel];
    }
    
}

-(void)reagendarReceita:(ObjectReceita *)receita
{
    self.navigationController.navigationBarHidden = NO;
    
    NSLog(@"Delegado Calendario");
    
    // tenho de abrir o calendario em modo de edição
    Calendario * calendarioEditar = [Calendario new];
    calendarioEditar.receita = receita.managedObject;
    calendarioEditar.calendario = receita.agendamento;
    calendarioEditar.delegate = self;
    
    [self.navigationController pushViewController:calendarioEditar animated:YES];
    // nao sei pk mas o calendario esta aparecer vazio
    
}

-(void)adicionarReceita:(ObjectReceita *) receita
{
    NSLog(@"Delegado ingredientes da receita %@", receita.nome);
    /* tenho de percorrer todos os ingredientes da receita e adicionar ao carrinho de compras :( vai ter de ter varias verificações para verificar se
     * o ingrediente já se encontra ou não guardado... se já estiver guardado tenho de apagar para poder adicionar de novo com os novos valores
     */
    
    
    NSMutableArray * arrayIngredientes = [NSMutableArray new];
    
    NSSet * resultados = [receita.managedObject valueForKey:@"contem_ingredientes"];
    for ( NSManagedObject * managedIngre in resultados )
    {
        ObjectIngrediente * ingrediente = [ObjectIngrediente new];
        [ingrediente setTheManagedObject:managedIngre];
        
        [arrayIngredientes addObject:ingrediente];
    }
    
    // ok agora neste ponto já tenho todos os ingredientes da receita
    // agora tenho de verificar se esses ingredientes já existem no shopping cart
    
    NSManagedObjectContext * context = [AppDelegate sharedAppDelegate].managedObjectContext;
    
    // para ir buscar os dados prestendidos a base de dados
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"ShoppingList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError * error;
    
    NSMutableArray * arrayShoppingList = [NSMutableArray new];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject * managedItemList in fetchedObjects)
    {
        ObjectLista * objLista = [ObjectLista new];
        [objLista setTheManagedObject:managedItemList forRecipe:receita];
        
        [arrayShoppingList addObject:objLista];
    }
    
    // aqui já tenho todos os ingredientes na shoping list pertencentes a todas as receitas
    // para todos os itens da receita vou ter de correr um ciclo que verifica se o ingrediente já existe ou nao no cart
    // se existir tenho de remover
    int count = 0;
    for (ObjectIngrediente * ingrediente in arrayIngredientes)
    {
        for (ObjectLista * listItem in arrayShoppingList)
        {
            if ([ingrediente.nome isEqualToString:listItem.nome] && [ingrediente.unidade isEqualToString:listItem.unidade])
            {
                [context deleteObject:listItem.managedObject];
                count = count +1;
            }
        }
    }
    
    // aqui já apaguei os que já estavam anteriormente na lista
    // entao agora tenho de adicionar todos os que tenho na lista a base de dados com mais um ciclo
    
    
    for (ObjectIngrediente * listIgre in arrayIngredientes)
    {
        // ele aqui devia gravar os ingredientes 1 a 1 na base de dados
        [listIgre gettheManagedObjectToList: context fromReceita: receita];
        
    }
    
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%d ingredients added to your shopping list", arrayIngredientes.count - count] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}







@end
