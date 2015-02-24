//
//  PesquisaReceitas.m
//  Fucook
//
//  Created by Hugo Costa on 14/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "PesquisaReceitas.h"
#import "ReceitaCell.h"
#import "AppDelegate.h"
#import "ObjectReceita.h"
#import "ReceitaVisualizar.h"
#import "Calendario.h"
#import "ObjectIngrediente.h"
#import "ObjectLista.h"


@interface PesquisaReceitas ()
{
    NSMutableArray  * receitas;
    NSMutableArray  * imagens;
    NSMutableArray  * pesquisaReceitas;
    NSString        * textoPesquisado;
}

@end

@implementation PesquisaReceitas

@synthesize searcBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUp];
    
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 10, 40)];
    [buttonback addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft1"] forState:UIControlStateNormal];
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;
    
    
    [self addCloseToTextView:self.searcBar];
}

-(void)addCloseToTextView:(UISearchBar *)textView
{
    UIView* numberToolbar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width -15 -44, 15.5, 44, 44)];
    [button addTarget:self action:@selector(doneWithTextArea) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"btntecladodown"] forState:UIControlStateNormal];
    
    [button setClipsToBounds:NO];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // finally do the magic
    float topInset = 14.0f;
    anotherButton.imageInsets = UIEdgeInsetsMake(topInset, 0.0f, -topInset, 0.0f);
    
    [numberToolbar setBackgroundColor:[UIColor clearColor]];
    
    [numberToolbar addSubview:button];
    
    //[numberToolbar sizeToFit];
    textView.inputAccessoryView = numberToolbar;
    
}

-(void)doneWithTextArea
{
    [self.searcBar resignFirstResponder];
}


- (IBAction)back:(id)sender
{
    [self.searcBar resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUp
{
    //UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    //searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searcBar.autoresizingMask = 0;
    searcBar.delegate = self;
    self.navigationItem.titleView = searcBar;
    
    // tenho de carregar todas as receitas de todos os livros
    
    textoPesquisado = @"";
    
    [self carregarReceitas];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    textoPesquisado = searchText;
    
    [pesquisaReceitas removeAllObjects];
    
    // fazer o codigo aqui para limpar as receitas
    for (ObjectReceita * receita in receitas)
    {
        if( [receita.nome rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound )
        //if ([receita.nome caseInsensitiveCompare:searchText ])
        {
            [pesquisaReceitas addObject:receita];
        }
    }
    
    [self actualizarImagens];
    //[self.tabela reloadData];
}


-(void)carregarReceitas
{
    [self actualizarImagens];
    receitas            = [NSMutableArray new];
    pesquisaReceitas    = [NSMutableArray new];
    
    NSManagedObjectContext * context = [AppDelegate sharedAppDelegate].managedObjectContext;
    
    // para ir buscar os dados prestendidos a base de dados
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Receitas" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject * managedReceita in fetchedObjects)
    {
        ObjectReceita * receita = [ObjectReceita new];
        [receita setTheManagedObject:managedReceita];
        
        [receitas addObject:receita];
    }
}

-(void)actualizarImagens
{
    imagens = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 1000; ++i)
    {
        [imagens addObject:[NSNull null]];
    }
    
    [self.tabela reloadData];
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pesquisaReceitas.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ReceitaCell";
    
    ReceitaCell *cell = (ReceitaCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReceitaCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ObjectReceita * rec = [pesquisaReceitas objectAtIndex:indexPath.row];
    
    cell.labelTitulo.text = rec.nome;//[rec.nome uppercaseString];
    cell.labelTempo.text = rec.tempo;
    cell.labelCategoria.text = [NSString stringWithFormat:@"%@ · %@ · %@",rec.tempo, rec.dificuldade , rec.categoria];
    cell.labelDificuldade.text = rec.dificuldade;
    cell.receita = rec;
    // tenho de calcular com base no que esta no header
    
    
    
    
    cell.delegate = self;
    
    // NSString *key = [livro.imagem.description MD5Hash];
    // NSData *data = [FTWCache objectForKey:key];
    if ( [imagens objectAtIndex:indexPath.row]!= [NSNull null] )
    {
        //UIImage *image = [UIImage imageWithData:data];
        cell.imagemReceita.image = [imagens objectAtIndex:indexPath.row];
    }
    else
    {
        //cell.imageCapa.image = [UIImage imageNamed:@"icn_default"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData * data = [rec.managedImagem valueForKey:@"imagem"];
            //[FTWCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            NSInteger index = indexPath.row;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image)
                {
                    cell.imagemReceita.image = image;
                    [imagens replaceObjectAtIndex:index withObject:image];
                }
                else
                {
                    cell.imagemReceita.image = [UIImage imageNamed:@"imgsample.png"];
                    [imagens replaceObjectAtIndex:index withObject:[UIImage imageNamed:@"imgsample.png"]];
                }
            });
        });
    }
    
    
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
    //[self.navigationController pushViewController:[ReceitaController new] animated:YES];
    //[self.navigationController presentViewController:[ReceitaController new] animated:YES completion:^{}];
    
    
    
    ObjectReceita * objR = [pesquisaReceitas objectAtIndex:indexPath.row];
    ReceitaVisualizar * visualizar = [ReceitaVisualizar new];
    visualizar.receita = objR;
    
    [self.navigationController pushViewController:visualizar animated:YES];
}

-(void)calendarioReceita:(NSManagedObject *)receitaManaged
{
    NSLog(@"Delegado Calendario");
    Calendario * cal = [Calendario new];
    cal.receita = receitaManaged;
    
    [self.navigationController pushViewController:cal animated:YES];
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
        [listIgre gettheManagedObjectToList:context fromReceita:receita ];
        
    }
    
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%lu ingredients added to your cart", arrayIngredientes.count - count] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}


@end
