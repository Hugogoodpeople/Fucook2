//
//  InApps.m
//  Fucook
//
//  Created by Hugo Costa on 27/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "InApps.h"
#import "FucookIAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "Settings.h"
#import "PesquisaReceitas.h"
#import "NewBook.h"
#import "WebServiceSender.h"
#import "ObjectLivro.h"
#import "ObjectReceita.h"
#import "ObjectIngrediente.h"
#import "ObjectDirections.h"
#import "NSData+Base64.h"

@interface InApps ()
{
    NSArray *_products;
    // Add new instance variable to class extension
    NSNumberFormatter * _priceFormatter;
    
    NSMutableArray * array_livros;
    
    WebServiceSender * listaIdsInApps;
    
    NSManagedObjectContext * context;
}

@end

@implementation InApps

-(void)dealloc
{
    if (listaIdsInApps) {
        [listaIdsInApps cancel];
    }
    listaIdsInApps = nil;
    
}


-(void)webserviceInApps
{
#warning colocar aqui o url correcto para poder abrir o webservice
    listaIdsInApps = [[WebServiceSender alloc] initWithUrl:@"http://www.fucook.com/webservices/get_all_books.php" method:@"" tag:1];
    listaIdsInApps.delegate = self;
    
    NSMutableDictionary * dict = [NSMutableDictionary new];
    // aqui nao tenho de enviar nada por enquanto
    
    [listaIdsInApps sendDict:dict];
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
                   
                        
                        receita.livro = livro;
                        
                        [arrayReceitas addObject:receita.managedObject];
                    }
                    
                    [livro AddToCoreData:context];
                    
                    // este tem de ser o ultimo passo a concluir
                    [livro.managedObject setValue:[NSSet setWithArray:[[NSArray alloc] initWithArray:arrayReceitas]]  forKey:@"contem_receitas"];
                    
                    [array_livros addObject:livro];
                    
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
    
    self.title = @"In App Books";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self reload];
    [self.refreshControl beginRefreshing];
    
    // Add to end of viewDidLoad
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    // Add to end of viewDidLoad
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restore" style:UIBarButtonItemStyleBordered target:self action:@selector(restoreTapped:)];
    
    
    /* bt search*/
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

    
    
    [self.toobar setFrame:CGRectMake(0, self.toobar.frame.origin.y -4, self.toobar.frame.size.width, 48)];
    
    context = [AppDelegate sharedAppDelegate].managedObjectContext;
    
    [self webserviceInApps];
    
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
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)clickcarrinho:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    if (self.delegate)
    {
        [self.delegate performSelector:@selector(clickCarrinho:) withObject:nil];
    }
}


- (IBAction)clickCalendario:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
    if (self.delegate) {
        [self.delegate performSelector:@selector(clickAgends:) withObject:nil];
    }
}
// 4
- (void)reload {
    _products = nil;
    [self.tableView reloadData];
    [[FucookIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 5
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    SKProduct * product = (SKProduct *) _products[indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    
    // Add to bottom of tableView:cellForRowAtIndexPath (before return cell)
    [_priceFormatter setLocale:product.priceLocale];
    cell.detailTextLabel.text = [_priceFormatter stringFromNumber:product.price];
    
    if ([[FucookIAPHelper sharedInstance] productPurchased:product.productIdentifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
    } else {
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buyButton.frame = CGRectMake(0, 0, 72, 37);
        [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
        buyButton.tag = indexPath.row;
        [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = buyButton;
    }
    
    return cell;
}


- (void)buyButtonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = _products[buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[FucookIAPHelper sharedInstance] buyProduct:product];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

// Add new method
- (void)restoreTapped:(id)sender {
    [[FucookIAPHelper sharedInstance] restoreCompletedTransactions];
}

@end