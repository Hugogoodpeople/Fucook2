//
//  Books.m
//  Fucook
//
//  Created by Hugo Costa on 03/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "Book.h"
#import "NewReceita.h"
#import "Calendario.h"
#import "AppDelegate.h"
#import "ObjectReceita.h"
#import "ObjectIngrediente.h"
#import "ObjectLista.h"
#import "ReceitaCell.h"
#import "ReceitaVisualizar.h"


@interface Book ()

@property NSManagedObject * receitaAApagar;


@end

@implementation Book

@synthesize imagens;

- (void)viewDidLoad {
    [super viewDidLoad];
    


    
    /* bt mais*/
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [button addTarget:self action:@selector(addreceita:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"btnaddbook"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = anotherButton;

    
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [buttonback addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft2"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;
    
    
    [self.tabela setContentInset:UIEdgeInsetsMake(70, 0, 4, 0)];
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [self actualizarTudo];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)addreceita:(id)sender {
    NSLog(@"clicou add");
    
    NewReceita *objYourViewController = [NewReceita new];
    objYourViewController.livro = self.livro;
    [self.navigationController pushViewController:objYourViewController animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)preencherTabela
{
    NSMutableArray * arrayTemp = [NSMutableArray new];
    
    NSSet * receitas = [self.livro.managedObject valueForKey:@"contem_receitas"];
    for (NSManagedObject *pedido in receitas)
    {
        ObjectReceita * receita = [ObjectReceita new];
        [receita setTheManagedObject:pedido];
        [arrayTemp addObject:receita];
    }
    
    
    // aqui tenho de organizar os objectos por data
    NSArray *sortedArray;
    sortedArray = [arrayTemp sortedArrayUsingSelector:@selector(compare:)];
    //[self.itemsDirections addObjectsFromArray: sortedArray];

    
    
   // NSArray* reversed = [[sortedArray reverseObjectEnumerator] allObjects];
    
    
    self.items = [NSMutableArray arrayWithArray:sortedArray];
    
    [self.tabela reloadData];
    
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



-(void)editarReceita:(ObjectReceita *) receita
{
    NSLog(@"Delegado Editar");
    
    
    NewReceita *objYourViewController = [NewReceita new];
    objYourViewController.livro = self.livro;
    objYourViewController.receita = receita;
    [self.navigationController pushViewController:objYourViewController animated:YES];
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

-(void)ApagarReceita:(NSManagedObject *) object
{
    NSLog(@"delegado apagar receita");
    
    self.receitaAApagar = object;
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Delete recipe?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            [self apagarReceita];
        }
    }
}

-(void)apagarReceita
{
    NSManagedObjectContext * context = [AppDelegate sharedAppDelegate].managedObjectContext;
    
    NSManagedObject * temp;
    
    // tenho de ir buscar a receita correcta ao livro para ser apagada
    NSSet * receitas = [self.livro.managedObject valueForKey:@"contem_receitas"];
    
    
    // porque que eu faço isto aqui??? posso passar directamente o valor e apagar logo
    // tipo [context deleteObject:self.receitaAApagar]; // e fica feito
    [context deleteObject:self.receitaAApagar];
  
    
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }
    
    [self actualizarTudo];

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
    
    cell.labelTitulo.text = rec.nome;
    cell.labelTempo.text = rec.tempo;
    cell.labelCategoria.text = rec.categoria;
    cell.labelDificuldade.text = rec.dificuldade;
    cell.receita = rec;
    // tenho de calcular com base no que esta no header
    
    //cell.labelQtd.text = [self calcularValor:indexPath];
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
                cell.imagemReceita.image = image;
                if (image)
                    [imagens replaceObjectAtIndex:index withObject:image];
            });
        });
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld", (long)indexPath.row);
    
    // tenho de ir buscar os valores a tabela para poder abrir o objecto correcto
    
    ObjectReceita * receita = [self.items objectAtIndex:indexPath.row];
    ReceitaVisualizar * recietas = [ReceitaVisualizar new];
    recietas.receita = receita;
    
    [self.navigationController pushViewController:recietas animated:YES];
    
}

- (IBAction)clickAddRecipe:(id)sender {
    [self addreceita:nil];
}
@end
