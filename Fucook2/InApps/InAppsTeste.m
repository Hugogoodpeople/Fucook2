//
//  InAppsTeste.m
//  Fucook2
//
//  Created by Hugo Costa on 17/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "InAppsTeste.h"
#import "FucookIAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "Settings.h"
#import "PesquisaReceitas.h"
#import "NewBook.h"
#import "WebServiceSender.h"
#import "ObjectReceita.h"
#import "ObjectIngrediente.h"
#import "ObjectDirections.h"
#import "NSData+Base64.h"
#import "InAppsCell.h"
#import "PreviewBook.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "FucookIAPHelper.h"

@interface InAppsTeste ()
{

    NSArray *_products;
    // Add new instance variable to class extension
    NSNumberFormatter * _priceFormatter;
    
    NSMutableArray * array_livros;
    
    WebServiceSender * listaIdsInApps;
    WebServiceSender * comparLivro;
    
    MBProgressHUD *HUD;
    
    NSManagedObjectContext * context;
    
    
    
}

@end

@implementation InAppsTeste

-(void)dealloc
{
    if (listaIdsInApps) {
        [listaIdsInApps cancel];
    }
    listaIdsInApps = nil;
    
    if (comparLivro) {
        [comparLivro cancel];
    }
    comparLivro = nil;
}


-(void)webserviceInApps
{
#warning colocar aqui o url correcto para poder abrir o webservice
    listaIdsInApps = [[WebServiceSender alloc] initWithUrl:@"http://www.fucook.com/webservices/get_all_books_url.php" method:@"" tag:1];
    listaIdsInApps.delegate = self;
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    // aqui nao tenho de enviar nada por enquanto
    
    [listaIdsInApps sendDict:dict];
    
    [self.loadingIndicator startAnimating];
}



-(void)sendCompleteWithResult:(NSDictionary*)result withError:(NSError*)error
{
    
    if (!error)
    {
        int tag=[WebServiceSender getTagFromWebServiceSenderDict:result];
        switch (tag)
        {
            case 1:
            {
                  NSLog(@"resultado da lista de inApps  =>  %@", result.description);
                
                array_livros = [NSMutableArray new];
                
                for (NSMutableDictionary * dictLivro in [result objectForKey:@"res"])
                {
                    ObjectLivro * livro = [ObjectLivro new];
                    
                    livro.titulo            = [dictLivro objectForKey:@"nome_livro"];
                    livro.descricao         = [dictLivro objectForKey:@"descricao_livro"];
                    livro.id_inapps         = [dictLivro objectForKey:@"id_inapp"];
                    livro.partilha          = [[dictLivro objectForKey:@"partilha"] intValue];
                    livro.id_livro          = [dictLivro objectForKey:@"id_livro"];
                    livro.comprado          = NO;
   
                    livro.urlImagem         = [dictLivro objectForKey:@"foto_livro"];
                    livro.urlImagem_partilha=[dictLivro objectForKey:@"foto_livro_partilha"];
                    
                    
                    // agora tenho de ir buscar as receitas e colocalas dentro do livro
                    
                    NSMutableArray * arrayReceitas = [NSMutableArray new];
                    
                    for (NSMutableDictionary * dictRec in [dictLivro objectForKey:@"receitas"])
                    {
                        ObjectReceita * receita     = [ObjectReceita new];
                        receita.nome                = [dictRec objectForKey:@"nome_receita"];
                        receita.categoria           = [dictRec objectForKey:@"categoria"];
                        receita.dificuldade         = [dictRec objectForKey:@"dificuldade"];
                        receita.notas               = [dictRec objectForKey:@"notas"];
                        receita.servings            = [dictRec objectForKey:@"nr_pessoas"];
                        receita.tempo               = [dictRec objectForKey:@"tempo"];
                        receita.gratis              = [dictRec objectForKey:@"gratis"];
                        receita.urlImagem           = [dictRec objectForKey:@"foto_receita"];
                        
                        
                        // agora tenho de ir buscar as etapas e os ingredientes
                        NSMutableArray * arrayIngredientes = [NSMutableArray new];
                        
                        for (NSMutableDictionary * dictIngre in [dictRec objectForKey:@"ingredientes"])
                        {
                            ObjectIngrediente * ingrediente = [ObjectIngrediente new];
                            ingrediente.nome                = [dictIngre objectForKey:@"nome_ingrediente"];
                            ingrediente.quantidadeDecimal   = @"";
                            ingrediente.quantidade          = [dictIngre objectForKey:@"quantidade"];
                            ingrediente.unidade             = [dictIngre objectForKey:@"unidade"];
                            
                            [arrayIngredientes addObject:ingrediente];
                        }
                        
                        
                        // para a parte das direcções/etapas
                        // agora tenho de ir buscar as etapas e os ingredientes
                        NSMutableArray * arrayEtapas = [NSMutableArray new];
                        
                        for (NSMutableDictionary * dictEtap in [dictRec objectForKey:@"etapas"])
                        {
                            ObjectDirections * direction    = [ObjectDirections new];
                            direction.descricao             = [dictEtap objectForKey:@"descricao"];
                            direction.passo                 = [[dictEtap objectForKey:@"ordem"] intValue];
                            direction.tempoMinutos          = [[dictEtap objectForKey:@"tempo_etapa"] intValue];
                            
                            [arrayEtapas addObject:direction];
                        }
                        
                        
                        
                        //[receita AddToCoreData:context];
                        
                        receita.arrayEtapas = arrayEtapas;
                        
                        receita.arrayIngredientes = arrayIngredientes;
                        
                        receita.livro = livro;
                        
                        [arrayReceitas addObject:receita];
                    }
                    
                    // agrora tambem tenho de saber se o livro contem receitas com todas as categorias existentes
                    BOOL breakFast = NO;
                    BOOL dinner = NO;
                    BOOL lunch = NO;
                    BOOL dessert = NO;
                    
                    for (ObjectReceita * receita in arrayReceitas)
                    {
                        
                        if ([receita.categoria rangeOfString:@"Breakfast"].location != NSNotFound) {
                            breakFast = YES;
                        }
                        if ([receita.categoria rangeOfString:@"Dinner"].location != NSNotFound) {
                            dinner = YES;
                        }
                        if ([receita.categoria rangeOfString:@"Lunch"].location != NSNotFound) {
                            lunch = YES;
                        }
                        if ([receita.categoria rangeOfString:@"Dessert"].location != NSNotFound) {
                            dessert = YES;
                        }
                        
                    }
                    
                    livro.breakFast = breakFast;
                    livro.dinner = dinner;
                    livro.lunch = lunch;
                    livro.dessert = dessert;

                    
                    livro.countReceitas = [NSString stringWithFormat:@"%lu", (unsigned long)arrayReceitas.count];
                    //[livro AddToCoreData:context];
                    
                    // este tem de ser o ultimo passo a concluir
                    livro.receitas = arrayReceitas;
                    
                    [array_livros addObject:livro];
                    
                }
                
                [self.tableView reloadData];
                
                [self.loadingIndicator stopAnimating];
                self.loadingIndicator.alpha = 0;
                
                break;
            }
            case 2:
            {
                NSLog(@"resultado da lista de inApps  =>  %@", result.description);
                
                array_livros = [NSMutableArray new];
                
                for (NSMutableDictionary * dictLivro in [result objectForKey:@"res"])
                {
                    ObjectLivro * livro = [ObjectLivro new];
                    
                    livro.titulo            = [dictLivro objectForKey:@"nome_livro"];
                    livro.descricao         = [dictLivro objectForKey:@"descricao_livro"];
                    livro.id_inapps         = [dictLivro objectForKey:@"id_inapp"];
                    livro.partilha          = [[dictLivro objectForKey:@"partilha"] intValue];
                    livro.id_livro          = [dictLivro objectForKey:@"id_livro"];
                    livro.comprado          = NO;
                    
                    NSManagedObject *managedImagem = [NSEntityDescription
                                                      insertNewObjectForEntityForName:@"Imagens"
                                                      inManagedObjectContext:context];
                    
                    // tenho de transformar o bsse64 em imagem
                    NSString * strData = [dictLivro objectForKey:@"foto_livro"];
                    
                    NSData *data = [[NSData alloc] initWithData:[NSData dataFromBase64String:strData]];
                    
                    //Now data is decoded. You can convert them to UIImage
                    //UIImage *image = [UIImage imageWithData:data];
                    
                    [managedImagem setValue:data forKey:@"imagem"];
                    
                    livro.managedImagem = managedImagem;
                    

                    // agora tenho de ir buscar as receitas e colocalas dentro do livro
                    
                    NSMutableArray * arrayReceitas = [NSMutableArray new];
                    
                    for (NSMutableDictionary * dictRec in [dictLivro objectForKey:@"receitas"])
                    {
                        ObjectReceita * receita     = [ObjectReceita new];
                        receita.nome                = [dictRec objectForKey:@"nome_receita"];
                        receita.categoria           = [dictRec objectForKey:@"categoria"];
                        receita.dificuldade         = [dictRec objectForKey:@"dificuldade"];
                        receita.notas               = [dictRec objectForKey:@"notas"];
                        receita.servings            = [dictRec objectForKey:@"nr_pessoas"];
                        receita.tempo               = [dictRec objectForKey:@"tempo"];
                        
                        NSString * dataCriado       = [dictRec objectForKey:@"data_criado"];
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        // this is imporant - we set our input date format to match our input string
                        // if format doesn't match you'll get nil from your string, so be careful
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSDate *megaData = [NSDate new];
                        // voila!
                        megaData = [dateFormatter dateFromString:dataCriado];
                        
                        receita.data_criado = megaData;
                        
                        NSManagedObject *managedImagem = [NSEntityDescription
                                                          insertNewObjectForEntityForName:@"Imagens"
                                                          inManagedObjectContext:context];
                        NSString * strData = [dictRec objectForKey:@"foto_receita"];
                        NSData *data = [[NSData alloc] initWithData:[NSData dataFromBase64String:strData]];
                        [managedImagem setValue:data forKey:@"imagem"];
                        
                        receita.managedImagem = managedImagem;
                        
                        
                        // agora tenho de ir buscar as etapas e os ingredientes
                        NSMutableArray * arrayIngredientes = [NSMutableArray new];
                        
                        for (NSMutableDictionary * dictIngre in [dictRec objectForKey:@"ingredientes"])
                        {
                            ObjectIngrediente * ingrediente = [ObjectIngrediente new];
                            ingrediente.nome                = [dictIngre objectForKey:@"nome_ingrediente"];
                            ingrediente.quantidadeDecimal   = @"";
                            ingrediente.quantidade          = [dictIngre objectForKey:@"quantidade"];
                            ingrediente.unidade             = [dictIngre objectForKey:@"unidade"];
                            
                            [arrayIngredientes addObject:[ingrediente getManagedObject:context]];
                        }
                        
                        
                        // para a parte das direcções/etapas
                        // agora tenho de ir buscar as etapas e os ingredientes
                        NSMutableArray * arrayEtapas = [NSMutableArray new];
                        
                        for (NSMutableDictionary * dictEtap in [dictRec objectForKey:@"etapas"])
                        {
                            ObjectDirections * direction    = [ObjectDirections new];
                            direction.descricao             = [dictEtap objectForKey:@"descricao"];
                            direction.passo                 = [[dictEtap objectForKey:@"ordem"] intValue];
                            direction.tempoMinutos          = [[dictEtap objectForKey:@"tempo_etapa"] intValue];
                            
                            [arrayEtapas addObject:[direction getManagedObject:context]];
                        }
                        
                        
                        
                        [receita AddToCoreData:context];
                        
                        [receita.managedObject setValue:[NSSet setWithArray:[[NSArray alloc] initWithArray:arrayEtapas]] forKey:@"contem_etapas"];
                        
                        [receita.managedObject setValue:[NSSet setWithArray:[[NSArray alloc] initWithArray:arrayIngredientes]] forKey:@"contem_ingredientes"];
                        
                        [receita.managedObject setValue:receita.managedImagem forKey:@"contem_imagem"];
                        
                        receita.livro = livro;
                        
                        [arrayReceitas addObject:receita.managedObject];
                    }
                    
                    [livro AddToCoreData:context];
                    
                    
                    // este tem de ser o ultimo passo a concluir
                    [livro.managedObject setValue:[NSSet setWithArray:[[NSArray alloc] initWithArray:arrayReceitas]]  forKey:@"contem_receitas"];
                
                    [livro.managedObject setValue:livro.managedImagem forKey:@"contem_imagem"];
                    
                    NSError *error = nil;
                    if (![context save:&error])
                    {
                        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
                        
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Cannot buy this book now, try later" delegate:nil cancelButtonTitle:@"ok"   otherButtonTitles:nil, nil];
                        [alert show];
                        
                        return;
                    }
                    else{
                   
                        //[LoadingaAlert dismissWithClickedButtonIndex:0 animated:YES];
                        [HUD hide:YES ];
                        
                        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Now you own this book" delegate:nil cancelButtonTitle:@"ok"   otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    
                    
                    
                     //[self comprarItem:livro];
                }
                

                break;
            }

        }
    }else
    {
        NSLog(@"webservice error %@", error.description);
    }
}



// 3
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Featured Collections";

    /* bt search*/
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [button addTarget:self action:@selector(clickSettings:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"btnsetting1"] forState:UIControlStateNormal];
    
    //UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    //self.navigationItem.leftBarButtonItem = anotherButton;
    
    /* bt add*/
    UIButton * buttonadd = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [buttonadd addTarget:self action:@selector(addbook) forControlEvents:UIControlEventTouchUpInside];
    [buttonadd setImage:[UIImage imageNamed:@"btnaddbook"] forState:UIControlStateNormal];
    
    //UIBarButtonItem *anotherButtonadd = [[UIBarButtonItem alloc] initWithCustomView:buttonadd];
    
    
    UIButton * buttonSettings = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [buttonSettings addTarget:self action:@selector(Findreceita) forControlEvents:UIControlEventTouchUpInside];
    [buttonSettings setImage:[UIImage imageNamed:@"btnsearch"] forState:UIControlStateNormal];
    
    //UIBarButtonItem *anotherButtonSettings = [[UIBarButtonItem alloc] initWithCustomView:buttonSettings];
    
    self.navigationItem.hidesBackButton = YES;
    
    //[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: anotherButton,anotherButtonadd, anotherButtonSettings, nil]];
    
    
    
    [self.toobar setFrame:CGRectMake(0, self.toobar.frame.origin.y -4, self.toobar.frame.size.width, 48)];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 48, 0)];
    
    context = [AppDelegate sharedAppDelegate].managedObjectContext;

    
    [self webserviceInApps];
    
    // para remover a linha da tollbar
    [self.toobar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.toobar setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.97f]];
    [self.toobar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];

    // [FucookIAPHelper sharedInstance].delegate = self;
    [self reload];
    
}




-(void)Findreceita
{
    [self.navigationController pushViewController:[PesquisaReceitas new] animated:YES];
}

- (IBAction)clickSettings:(id)sender
{
    [self presentViewController:[Settings new] animated:YES completion:^{}];
}

-(void)addbook {
    NSLog(@"clicou add");
    
    NewBook *objYourViewController = [[NewBook alloc] initWithNibName:@"NewBook" bundle:nil];
    [self.navigationController pushViewController:objYourViewController animated:YES];
}

- (IBAction)clickHome:(id)sender
{
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self.navigationController popViewControllerAnimated:NO];
    });

}

- (IBAction)clickcarrinho:(id)sender
{
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self.navigationController popToRootViewControllerAnimated:NO];
        if (self.delegate)
        {
            [self.delegate performSelector:@selector(clickCarrinho:) withObject:nil];
        }
    });
    
    
}


- (IBAction)clickCalendario:(id)sender {
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        [self.navigationController popToRootViewControllerAnimated:NO];
        if (self.delegate) {
            [self.delegate performSelector:@selector(clickAgends:) withObject:nil];
        }
    });
}
// 4


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 228 ;
}

// 5
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array_livros.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InAppsCell";
    
    
    InAppsCell *cell = (InAppsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InAppsCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    ObjectLivro * liv = [array_livros objectAtIndex:indexPath.row];
    
    cell.labelCategoria.text = @"categorias dentro do livro aqui";
    cell.labelTitulo.text = liv.titulo;
    cell.labelDescricao.text = liv.descricao;
    cell.labelNumeroReceitas.text = liv.countReceitas;
    cell.livro = liv;
    // sabendo o numero de receitas tenho de editar a label que diz recipes
    
    if ([liv.countReceitas intValue] == 1)
    {
        cell.labelRecipes.text = @"RECIPE";
    }
    else
    {
        cell.labelRecipes.text = @"RECIPES";
    }
    
    cell.delegate = self;
    

    [cell.imagemLivro sd_setImageWithURL:[NSURL URLWithString:liv.urlImagem ] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        liv.imagem = image;
    }];
    //cell.imagemLivro.image = liv.imagem;
    
    if (liv.partilha == 1)
    {
        cell.viewBloqueada.alpha = 1;
        cell.viewAdquirida.alpha = 0;
    }
    else
    {
        cell.viewBloqueada.alpha = 0;
        cell.viewAdquirida.alpha = 1;
    }
    
    cell.labelCategoria.text = @"";
    int larguraview = 28;
    
    // tenho de verificar o cenas para ver se o livro tem as cetegorias
    // tenho de verificar o cenas para ver se o livro tem as cetegorias
    if (liv.breakFast)
    {
        cell.labelCategoria.text = @" Breakfast  ";
        larguraview = larguraview + 45;
    }
    if (liv.dinner)
    {
        cell.labelCategoria.text = [NSString stringWithFormat:@"%@ Dinner  ", cell.labelCategoria.text ];
        larguraview = larguraview + 35;
    }
    if (liv.dessert)
    {
        cell.labelCategoria.text = [NSString stringWithFormat:@"%@ Dessert  ", cell.labelCategoria.text ];
        larguraview = larguraview + 40;
    }
    if (liv.lunch)
    {
        cell.labelCategoria.text = [NSString stringWithFormat:@"%@ Lunch", cell.labelCategoria.text ];
        larguraview = larguraview + 40;
    }
    
    [cell.viewCategoria setFrame:CGRectMake(cell.viewCategoria.frame.origin.x,
                                            cell.viewCategoria.frame.origin.y,
                                            larguraview,
                                            cell.viewCategoria.frame.size.height)];
    
    [cell setSelected:false animated:NO];
    
    
   
    // [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
    // cell.buttonAdd1.tag = indexPath.row;
    // [cell.buttonAdd1 addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // cell.buttonAdd2.tag = indexPath.row;
    // [cell.buttonAdd2 addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    // cell.accessoryType = UITableViewCellAccessoryNone;
    // cell.accessoryView = buyButton;
    
 
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld", (long)indexPath.row);
    
    // tenho de ir buscar os valores a tabela para poder abrir o objecto correcto
    
    ObjectLivro * livro = [array_livros objectAtIndex:indexPath.row];
    
    if ([self ExisteLivro:livro])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You already have this recipe´s book" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
    
        PreviewBook * recietas = [PreviewBook new];
        recietas.livro = livro;
        recietas.products = [_products copy] ;
        recietas.delegate = self;
        recietas.context = context;
    
        [self.navigationController pushViewController:recietas animated:YES];
    }
    
}

-(void)comprarLivro:(ObjectLivro *)Livro
{
    // tenho de pegar no livro de adicionar ao core data do utilizador :!
    
    // antes de adicionar o livro tenho de ir ao coredata verificar se este livro já lá existe e se sim nao posso adicionar de novo
    if ([self ExisteLivro:Livro])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Ups" message:@"You alredy have this book" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        //[Livro AddToCoreData:context];
        // apesar de dizer get all books no webservice na realidade ele so busca 1... lol
        comparLivro = [[WebServiceSender alloc] initWithUrl:@"http://www.fucook.com/webservices/get_all_books.php" method:@"" tag:2];
        comparLivro.delegate = self;
        
        NSMutableDictionary * dict = [NSMutableDictionary new];
        [dict setObject:Livro.id_livro forKey:@"id_livro"];
        
        [comparLivro sendDict:dict];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        
        [HUD show:YES];
    }
    
}

-(BOOL)ExisteLivro:(ObjectLivro *)livro
{
    BOOL existe = NO;
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Livros"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_livro = %@", livro.id_livro];
    [fetch setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetch error:&error];
    if(results) {
        NSLog(@"Entities with that name: %@", results);
        for(NSManagedObject *p in results) {
            existe = YES;
        }
    } else {
        NSLog(@"Error: %@", error);
    }

    return existe;
}

/*
- (void)buyButtonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = _products[buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[FucookIAPHelper sharedInstance] buyProduct:product];
    
}
 */

-(void)adicionarLivro
{
    [self comprarLivro:self.livro];
}


// completamente inutil aqui agora... mas como está a funcionar deixo estar
-(void)comprarItem:(ObjectLivro *)livro
{
    // aqui tenho de encontrar o produto dentro de _products
    // se conseguir encontrar entao faço a compra, senao considero que nao preciso de adicionar as inApps
    
    self.livro = livro;
    
    for (SKProduct * prod in _products)
    {
        if ([prod.productIdentifier isEqualToString:livro.id_inapps])
        {
            NSLog(@"Buying %@...", prod.productIdentifier);
            [[FucookIAPHelper sharedInstance] buyProduct:prod];

        }
        
    }
    
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
    
}

- (void)reload {
    _products = nil;
    [self.tableView reloadData];
    [[FucookIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (self) {
        
            if (success) {
                _products = products;
                [self.tableView reloadData];
            }
            [self.refreshControl endRefreshing];
        }
    }];
}


@end
