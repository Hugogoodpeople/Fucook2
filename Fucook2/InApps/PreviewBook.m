//
//  PreviewBook.m
//  Fucook2
//
//  Created by Hugo Costa on 17/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "PreviewBook.h"
#import "ReceitaCell.h"
#import "UIImageView+WebCache.h"
#import "ReceitaVisualizar.h"
#import <StoreKit/StoreKit.h>
#import "FucookIAPHelper.h"
#import "WebServiceSender.h"
#import "MBProgressHUD.h"
#import "NSData+Base64.h"
#import "ObjectIngrediente.h"
#import "ObjectDirections.h"
#import "ShareFucook.h"
#import <Social/Social.h>

@interface PreviewBook ()
{

   WebServiceSender * comparLivro;
    
    MBProgressHUD *HUD;
    
}

@end

@implementation PreviewBook

@synthesize products, context;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = self.livro.titulo;
    
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 10, 40)];
    [buttonback addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft1"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    //self.navigationItem.leftBarButtonItem = anotherButtonback;
    
    
    [self.tabela setContentInset:UIEdgeInsetsMake(70, 0, 4, 0)];
    
    /* bt search */
    
    // tenho de verificar se este livro pode ser partilhado ou nao
    // se der para ser partilhado entao tenho de fazer o cenas das partilhas aqui tbm
    
    
    
     UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 60, 32)];
    
    if (self.livro.partilha == 0) {
        [button addTarget:self action:@selector(comprarItem) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"btnbuy2"] forState:UIControlStateNormal];
    }
    else
    {
        [button addTarget:self action:@selector(partilharFacebook:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"btnunlock"] forState:UIControlStateNormal];
    }
    
    
     
     UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:button];
     //self.navigationItem.rightBarButtonItem = anotherButton;
     
     UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
     [negativeSpacer setWidth:15];
     
     self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:anotherButtonback,negativeSpacer,anotherButton,negativeSpacer,nil];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading";

    
}

-(void)actualizarTudo
{
    [self preencherTabela];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self actualizarTudo];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)preencherTabela
{
    self.items = self.livro.receitas;
}

#pragma table

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"ReceitaCell";
    
    ReceitaCell *cell = (ReceitaCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReceitaCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ObjectReceita * rec = [self.items objectAtIndex:indexPath.row];
    
    if (![rec.gratis isEqualToString:@"nao"])
    {
        cell.viewFree.alpha = 1;
    }
    else
    {
        cell.viewFree.alpha = 0;
    }
    
    cell.labelTitulo.text = rec.nome;
    cell.labelTempo.text = rec.tempo;
    //cell.labelCategoria.text = rec.categoria;
    cell.labelCategoria.text = [NSString stringWithFormat:@"%@ · %@ · %@",rec.tempo, rec.dificuldade , [rec.categoria stringByReplacingOccurrencesOfString:@" " withString:@" · "]];
    cell.labelDificuldade.text = rec.dificuldade;
    cell.pode = YES;
    cell.receita = rec;
    // tenho de calcular com base no que esta no header
    
    //cell.labelQtd.text = [self calcularValor:indexPath];
    //cell.delegate = self;
    
    [cell.imagemReceita sd_setImageWithURL:[NSURL URLWithString:rec.urlImagem ] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        rec.imagem = image;
    }];
    
    
    // tenho de ajustar o texto ao fundo... tipo?
    
    CGSize textSize = [cell.labelTitulo.text sizeWithFont:[UIFont fontWithName:@"Baskerville" size:30] constrainedToSize:CGSizeMake(cell.labelTitulo.frame.size.width, 20000) lineBreakMode: NSLineBreakByWordWrapping];
    
    float heightToAdd = MIN(textSize.height, 100.0f) + 10; //Some fix height is returned if height is small or change it to MAX(textSize.height, 150.0f); // whatever best fits for you
    
    if (heightToAdd > 80) {
        heightToAdd = 80;
    }
    
    [cell.labelTitulo setFrame:CGRectMake(cell.labelTitulo.frame.origin.x,
                                          cell.frame.size.height - heightToAdd - 10,
                                          cell.labelTitulo.frame.size.width,
                                          heightToAdd)];
    
    
    [cell.viewAumentea setFrame:CGRectMake(cell.viewAumentea.frame.origin.x,
                                           cell.labelTitulo.frame.origin.y - 30,
                                           cell.viewAumentea.frame.size.width,
                                           cell.viewAumentea.frame.size.height)];

    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld", (long)indexPath.row);
    
    // tenho de ir buscar os valores a tabela para poder abrir o objecto correcto
    
    ObjectReceita * receita = [self.items objectAtIndex:indexPath.row];
    
    if (![receita.gratis isEqualToString:@"nao"])
    {
        ReceitaVisualizar * recietas = [ReceitaVisualizar new];
        recietas.receita = receita;
        recietas.isFromInApps = NO;
        
        [self.navigationController pushViewController:recietas animated:YES];
    }
    else
    {
        /*
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"This recipe is not free, to get access you need to buy the book" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        */
         
        ReceitaVisualizar * recietas = [ReceitaVisualizar new];
        recietas.receita = receita;
        recietas.isFromInApps = YES;
        
        [self.navigationController pushViewController:recietas animated:YES];

    }

}

-(void)comprarItem
{
    // aqui tenho de encontrar o produto dentro de _products
    // se conseguir encontrar entao faço a compra, senao considero que nao preciso de adicionar as inApps
    
    [HUD show:YES];
    
    
    for (SKProduct * prod in products)
    {
        if ([prod.productIdentifier isEqualToString:self.livro.id_inapps])
        {
            NSLog(@"Buying %@...", prod.productIdentifier);
            [FucookIAPHelper sharedInstance].delegate = self;
            [[FucookIAPHelper sharedInstance] buyProduct:prod];
            
            
        }
        
    }
    
}

-(void)fecharHUD
{
    [HUD hide:YES ];
}

-(void)adicionarLivro
{
    /*
    if (self.delegate) {
        [self.delegate performSelector:@selector(comprarLivro:) withObject:self.livro];
    }
    */
    [self comprarLivro:self.livro];
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

-(void)sendCompleteWithResult:(NSDictionary*)result withError:(NSError*)error
{
    
    if (!error)
    {
        int tag=[WebServiceSender getTagFromWebServiceSenderDict:result];
        switch (tag)
        {
            
            case 2:
            {
                NSLog(@"resultado da lista de inApps  =>  %@", result.description);
                
                //NSMutableArray *  array_livros = [NSMutableArray new];
                
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
                        //[alert show];
                    }
                    
                    //[self comprarItem:livro];
                }
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
                break;
            }
                
        }
    }else
    {
        NSLog(@"webservice error %@", error.description);
    }
}

// tenho de fazer #import <Social/Social.h> para funcionar
- (IBAction)partilharFacebook:(id)sender {
    
    
    ShareFucook * share = [ShareFucook new];
    share.delegate = self.delegate;
    share.livro = self.livro;
    share.isInInApps = YES;
    share.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:share animated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
            share.viewEscura.alpha = 0.6;
        }];}];
    
}




@end

