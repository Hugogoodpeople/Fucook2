//
//  Home.m
//  Fucook
//
//  Created by Hugo Costa on 05/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "Home.h"

#import "NewBook.h"
#import "Settings.h"
#import "Book.h"
#import "MealPlanner.h"
#import "PesquisaReceitas.h"
#import "AppDelegate.h"
#import "ObjectLivro.h"
#import "UIImage+fixOrientation.h"
#import "ListaCompras.h"
#import "InAppsTeste.h"
#import "HomeCell.h"
#import "ObjectReceita.h"

@interface Home ()
{
    NSManagedObject * managedObject;
    NSManagedObjectContext * context;
}


@property bool selectedView;

@end

@implementation Home
@synthesize imagens;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    context = [AppDelegate sharedAppDelegate].managedObjectContext;
    
    [self actualizarTudo];
}

-(void)actualizarTudo
{
    [self actualizarImagens];
    [self preencherTabela];
}

-(void)actualizarImagens
{
    imagens = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 1000; ++i)
    {
        [imagens addObject:[NSNull null]];
    }
    
    //[self.tableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

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
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: anotherButton,anotherButtonadd, anotherButtonSettings, nil]];

    
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [self.navigationItem setTitleView:titleView];

    UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [aFlowLayout setItemSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/2, ([UIScreen mainScreen].bounds.size.height/2) -56 ) ];
    [aFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [aFlowLayout setMinimumInteritemSpacing:0];
    [aFlowLayout setMinimumLineSpacing:0];

    
    // para mudar a cor da toolbar
    /*
    [self.yoolbar setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.97f]];
    [self.yoolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.yoolbar.clipsToBounds = YES;
     */
    
    
    //[self preencherTabela];
    
    [self.toobar setFrame:CGRectMake(0, self.toobar.frame.origin.y -4, self.toobar.frame.size.width, 48)];
    
 
    [self.table setContentInset:UIEdgeInsetsMake(64, 0, 56, 0)];
    
    
}


-(void)preencherTabela
{
    NSMutableArray * items = [NSMutableArray new];
    
    //context = [AppDelegate sharedAppDelegate].managedObjectContext;
    
    // para ver se deu algum erro ao inserir
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
    // para ir buscar os dados pretendidos a base de dados
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Livros" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *pedido in fetchedObjects)
    {
        
        /*
        NSLog(@"************************************ Pedido ************************************");
        NSLog(@"titulo: %@", [pedido valueForKey:@"titulo"]);
        NSLog(@"descrição: %@", [pedido valueForKey:@"descricao"]);
        */
        ObjectLivro * livro = [ObjectLivro new];
        
        // para mais tarde poder apagar
        livro.managedObject = pedido;
        
        
        livro.titulo =[pedido valueForKey:@"titulo"];
        livro.descricao =[pedido valueForKey:@"descricao"];
        livro.comprado = [[pedido valueForKey:@"comprado"] boolValue];
        livro.id_livro = [pedido valueForKey:@"id_livro"];
        livro.managedObject = pedido;
        
        NSManagedObject * imagem = [pedido valueForKey:@"contem_imagem"];
        livro.managedImagem = imagem;
        
        // agora tambem tenho de contar o numero de receitas que existem dentro do livro
         NSSet * receitas = [pedido valueForKey:@"contem_receitas"];
        livro.countReceitas = [NSString stringWithFormat:@"%lu", (unsigned long)receitas.count];
        
        // agrora tambem tenho de saber se o livro contem receitas com todas as categorias existentes
        BOOL breakFast = NO;
        BOOL dinner = NO;
        BOOL lunch = NO;
        BOOL dessert = NO;
        
        for (NSManagedObject * managedReceita in receitas)
        {
            ObjectReceita * receita = [ObjectReceita new];
            [receita setTheManagedObject:managedReceita];
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
        
        // o livro tem de ter sido comprado para poder aparecer na lista do utilizador
        //if (livro.comprado)
            [items addObject:livro];
    }


    NSArray* reversed = [[items reverseObjectEnumerator] allObjects];

    
    self.items = [NSMutableArray arrayWithArray:reversed];
    

    [self.table reloadData];
    
    if (self.items.count == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.viewVazia.alpha = 1;
        }];
    }
    else
    {
         self.viewVazia.alpha = 0;
    }
    
}

-(void)Findreceita
{
    [self.navigationController pushViewController:[PesquisaReceitas new] animated:YES];
}

-(void)abrirLivro:(ObjectLivro *)livro
{
    Book * receitas = [Book new];
    receitas.livro =livro;
    
    [self.navigationController pushViewController:receitas animated:YES];
}



-(void)addbook {
    NSLog(@"clicou add");

    NewBook *objYourViewController = [[NewBook alloc] initWithNibName:@"NewBook" bundle:nil];
    [self.navigationController pushViewController:objYourViewController animated:YES];
}

-(void)editBook:(NSManagedObject *) managedObject
{
    NSLog(@"clicou add");
    
    NewBook *objYourViewController = [[NewBook alloc] initWithNibName:@"NewBook" bundle:nil];
    objYourViewController.managedObject = managedObject;
    [self.navigationController pushViewController:objYourViewController animated:YES];

}

-(void)apagarLivro:(NSManagedObject*)mo
{
    
    managedObject = mo;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to delete this recipe book?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.tag = 1;
    [alert show];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            
            
            [context deleteObject:managedObject];
            
            // tenho de actualizar as tabelas
            [self actualizarTudo];
            
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                return;
            }
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.navigationController.toolbarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld", (long)indexPath.row);
    
    // tenho de ir buscar os valores a tabela para poder abrir o objecto correcto
    
    ObjectLivro * livro = [self.items objectAtIndex:indexPath.row];
    Book * recietas = [Book new];
    recietas.livro = livro;
    
    [self.navigationController pushViewController:recietas animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickHome:(id)sender {
}

- (IBAction)clickCarrinho:(id)sender {
    ListaCompras * lista = [ListaCompras new];
    lista.delegate = self;
    
    [self.navigationController pushViewController:lista animated:NO];
}

- (IBAction)clickAgends:(id)sender {
    MealPlanner * meal = [MealPlanner new];
    meal.delegate = self;
    [self.navigationController pushViewController:meal animated:NO];
}


- (IBAction)clickInApps:(id)sender
{
    InAppsTeste * apps = [InAppsTeste new];
    apps.delegate = self;
    
    [self.navigationController pushViewController:apps animated:NO];
}

- (IBAction)clickSettings:(id)sender
{
    [self presentViewController:[Settings new] animated:YES completion:^{}];
}

#pragma table

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 228 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"HomeCell";
    
    HomeCell *cell = (HomeCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ObjectLivro * liv = [self.items objectAtIndex:indexPath.row];
    
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
    
    //cell.labelQtd.text = [self calcularValor:indexPath];
    cell.delegate = self;
    
    // NSString *key = [livro.imagem.description MD5Hash];
    // NSData *data = [FTWCache objectForKey:key];
    if ( [imagens objectAtIndex:indexPath.row] != [NSNull null] )
    {
        //UIImage *image = [UIImage imageWithData:data];
        cell.imagemLivro.image = [imagens objectAtIndex:indexPath.row];
    }
    else
    {
        //cell.imageCapa.image = [UIImage imageNamed:@"icn_default"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData * data = [liv.managedImagem valueForKey:@"imagem"];
            //[FTWCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            NSInteger index = indexPath.row;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imagemLivro.image = image;
                if (image)
                    [imagens replaceObjectAtIndex:index withObject:image];
            });
        });
    }
    
    /*
    [cell.imgBreakfast setImage:[UIImage imageNamed:@"icouncheck"]];
    [cell.imgDinner setImage:[UIImage imageNamed:@"icouncheck"]];
    [cell.imgDessert setImage:[UIImage imageNamed:@"icouncheck"]];
    [cell.imgLunch setImage:[UIImage imageNamed:@"icouncheck"]];
    */
    
    cell.labelCategoria.text = @"";
    int larguraview = 28;
    
    // tenho de verificar o cenas para ver se o livro tem as cetegorias
    // tenho de verificar o cenas para ver se o livro tem as cetegorias
    if (liv.breakFast)
    {
        cell.labelCategoria.text = @" Breakfast";
        larguraview = larguraview + 40;
    }
    if (liv.dinner)
    {
        cell.labelCategoria.text = [NSString stringWithFormat:@"%@ Dinner", cell.labelCategoria.text ];
        larguraview = larguraview + 30;
    }
    if (liv.dessert)
    {
        cell.labelCategoria.text = [NSString stringWithFormat:@"%@ Dessert", cell.labelCategoria.text ];
        larguraview = larguraview + 35;
    }
    if (liv.lunch)
    {
        cell.labelCategoria.text = [NSString stringWithFormat:@"%@ Lunch", cell.labelCategoria.text ];
        larguraview = larguraview + 35;
    }
    
    [cell.viewCategoria setFrame:CGRectMake(cell.viewCategoria.frame.origin.x,
                                            cell.viewCategoria.frame.origin.y,
                                            larguraview,
                                            cell.viewCategoria.frame.size.height)];

    
    [cell setSelected:false animated:NO];

    return cell;
}


- (IBAction)clickAddBook:(id)sender {
    [self addbook];
}
@end
