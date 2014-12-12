//
//  ReceitaVisualizar.m
//  Fucook2
//
//  Created by Hugo Costa on 10/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "ReceitaVisualizar.h"
#import "HeaderIngrediente.h"
#import "IngredienteCellTableViewCell.h"
#import "ObjectLista.h"
#import "ObjectDirections.h"
#import "DirectionsCell.h"
#import "IngredientesHeader.h"
#import "DirectionsHeader.h"
#import "Calendario.h"
#import "NotesViewer.h"

@interface ReceitaVisualizar ()
{
    HeaderIngrediente       * header;
    IngredientesHeader      * ingHeadercell;
    DirectionsHeader        * dirHeaderCell;
    NSManagedObjectContext  * context ;
    float largura;
}

@property NSMutableArray * shopingCart;
@property BOOL cartAllSelected;


@end

@implementation ReceitaVisualizar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [buttonback addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft2"] forState:UIControlStateNormal];
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;

    
    
    largura = [[UIScreen mainScreen] bounds].size.width;
    
    //[self.tabela setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    
    self.cartAllSelected = YES;
    
    context = [AppDelegate sharedAppDelegate].managedObjectContext;
    ingHeadercell = [IngredientesHeader new];
    [ingHeadercell.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 108)];
    
    dirHeaderCell = [DirectionsHeader new];
    [dirHeaderCell.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 108)];
    
    [self initializeShoppingCart];
    [self setUpIngredientes];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpIngredientes
{
    // apenas para textes
    self.items = [NSMutableArray new];
    
    [self.items addObject:[NSNull new]];
    
    // tenho de verificar aqui se os ingredientes já estão na shopinglist
    NSSet * receitas = [self.receita.managedObject valueForKey:@"contem_ingredientes"];
    for (NSManagedObject *pedido in receitas)
    {
        ObjectIngrediente * ingred = [ObjectIngrediente new];
        
        // para mais tarde poder apagar
        ingred.managedObject        = pedido;
        ingred.nome                 = [pedido valueForKey:@"nome"];
        ingred.quantidade           = [pedido valueForKey:@"quantidade"];
        ingred.quantidadeDecimal    = [pedido valueForKey:@"quantidade_decimal"];
        ingred.unidade              = [pedido valueForKey:@"unidade"];
        ingred.selecionado          = [self verificarShoppingList:ingred];
        
        [self.items addObject:ingred];
    }
    
    header = [HeaderIngrediente new];
    header.delegate = self;
    
    
    header.dificuldade      = self.receita.dificuldade;
    header.tempo            = self.receita.tempo;
    header.nome             = self.receita.nome;
    header.servings         = self.receita.servings;
    NSData * data           = [self.receita.imagem valueForKey:@"imagem"];
    
    
    header.imagem = [UIImage imageWithData:data];
    
    
    // afinal nao o posso colocar dentro da tabela :( e tbm tenho de alterar o contentinsent para ajustar a nova posição do cenas
    //self.tabela.tableHeaderView = header.view;
    
    [header.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, header.view.frame.size.height)];
    [self.tabela addSubview:header.view];

    UIView * viewDesnecessaria = [[UIView alloc] init];
    [viewDesnecessaria setFrame:CGRectMake(0, 0, self.view.frame.size.width, header.view.frame.size.height +64)];
    self.tabela.tableHeaderView = viewDesnecessaria;

    //[self.tabela setContentInset:UIEdgeInsetsMake(header.view.frame.size.height, 0, 20, 0)];
    
    
    //[self.tabela setContentInset:UIEdgeInsetsMake(100, 0, 20, 0)];
    
    [self setUpDirections];
    // para ter a certeza que todos já executaram tenho de fazer um de cada vez
    
}



-(void)setUpDirections
{
    self.itemsDirections = [NSMutableArray new];
    [self.itemsDirections addObject:[NSNull new]];
    
    NSSet * receitas = [self.receita.managedObject valueForKey:@"contem_etapas"];
    int passo = 0;
    
    NSMutableArray * arrayTemp = [NSMutableArray new];
    for (NSManagedObject *pedido in receitas)
    {
        passo = passo+1;
        
        ObjectDirections * directs = [ObjectDirections new];
        
        // para mais tarde poder apagar
        //directs.managedObject         = pedido;
        directs.passo                 = [[pedido valueForKey:@"ordem"] intValue];
        directs.descricao             = [pedido valueForKey:@"descricao"];
        
        // tenho de remover o cenas
        NSString * tempo = [pedido valueForKey:@"tempo"];
        
        directs.tempoMinutos          = tempo.intValue;
        
        [arrayTemp addObject:directs];
    }
    
    //  [[self.items  reverseObjectEnumerator] allObjects];
    
    
    NSArray *sortedArray;
    sortedArray = [arrayTemp sortedArrayUsingSelector:@selector(compare:)];
    
    [self.itemsDirections addObjectsFromArray: sortedArray];
    
    
    [self.tabela reloadData];
}


-(BOOL)verificarShoppingList:(ObjectIngrediente *) ingrediente
{
    BOOL tem = NO;
    
    
    for (ObjectLista * list in self.shopingCart) {
        if ([list.nome isEqualToString:ingrediente.nome] &&
            [list.unidade isEqualToString:ingrediente.unidade] /* &&
                                                                [list.quantidade isEqualToString:ingrediente.quantidade] &&
                                                                [list.quantidade_decimal isEqualToString:ingrediente.quantidadeDecimal] */)
        {
            tem = YES;
        }
    }
    return tem;
}

-(void)initializeShoppingCart
{
    self.shopingCart = [NSMutableArray new];
    
    NSError *error;
    /*
     if (![context save:&error]) {
     NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
     }
     */
    
    // para ir buscar os dados prestendidos a base de dados
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"ShoppingList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];

    for (NSManagedObject *pedido in fetchedObjects)
    {
        
        NSLog(@"************************************ Shopping list ************************************");
        NSLog(@"nome: %@", [pedido valueForKey:@"nome"]);
        NSLog(@"quantidade: %@", [pedido valueForKey:@"quantidade"]);
        NSLog(@"unidade: %@", [pedido valueForKey:@"unidade"]);
        ObjectLista * list = [ObjectLista new];
        
        [list setTheManagedObject:pedido forRecipe:self.receita];
        
        //[items addObject:list];
        
        // tenho de fazer aqui a comparação e se encontrar entao tenho de remover da base de dados
        [self.shopingCart addObject:list];
    }
    
}

-(void)deleteIngrediente:(ObjectIngrediente *) ingrediente
{
    NSLog(@"remover %@", ingrediente.nome);
    // tenho de percorrer todos os ingredientes na shopping list e remover o selecionado
    
    
    // para ver se deu algum erro ao inserir
    NSError *error;
    /*
     if (![context save:&error]) {
     NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
     }
     */
    
    // para ir buscar os dados prestendidos a base de dados
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.returnsObjectsAsFaults = NO;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"ShoppingList" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *pedido in fetchedObjects)
    {
        
        NSLog(@"************************************ Shopping list ************************************");
        NSLog(@"nome: %@", [pedido valueForKey:@"nome"]);
        NSLog(@"quantidade: %@", [pedido valueForKey:@"quantidade"]);
        NSLog(@"unidade: %@", [pedido valueForKey:@"unidade"]);
        ObjectLista * list = [ObjectLista new];
        
        // para mais tarde poder apagar
        list.managedObject = pedido;
        
        list.nome =[pedido valueForKey:@"nome"];
        list.quantidade =[pedido valueForKey:@"quantidade"];
        list.quantidade_decimal =[pedido valueForKey:@"quantidade_decimal"];
        list.unidade =[pedido valueForKey:@"unidade"];
        
        // [items addObject:list];
        // tenho de fazer aqui a comparação e se encontrar entao tenho de remover da base de dados
        
        if ([list.nome isEqualToString:ingrediente.nome] &&
            [list.unidade isEqualToString:ingrediente.unidade] /* &&
                                                                [list.quantidade isEqualToString:ingrediente.quantidade] &&
                                                                [list.quantidade_decimal isEqualToString:ingrediente.quantidadeDecimal]*/)
        {
            [context deleteObject:list.managedObject];
            [self.shopingCart removeObject: list];
        }
    }
}

-(void)saveIngrediente:(ObjectIngrediente *) ingrediente
{
    // tenhe de verificar se o ingrediente ja foi inserido antes de poder adicionar de novo
    // quando for salvar os ingredientes tenho de ter em conta a quantidade de servings que tem de mudar os valores na tabela
    // como é que vou mudar os valores na tabela?
    
    BOOL  podeGravar = YES;
    if (self.shopingCart.count == 0) {
        podeGravar = YES;
    }
    else
        // aqui vai ter de ir buscar sempre a base de dados
        for (ObjectLista * ing in self.shopingCart)
        {
            if ([ing.nome isEqualToString:ingrediente.nome] &&
                [ing.unidade isEqualToString:ingrediente.unidade] /* &&
                                                                   [ing.quantidade isEqualToString:ingrediente.quantidade] &&
                                                                   [ing.quantidade_decimal isEqualToString:ingrediente.quantidadeDecimal] */)
            {
                podeGravar = NO;
            }
            
        }
    
    if (podeGravar)
    {
        NSLog(@"adicionar %@", ingrediente.nome);
        
        // aqui é a criar pla primeira vez tenho de criar assim
        // não existe nenhum mecanismo automatico para esta parte
        NSManagedObject *listItem = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"ShoppingList"
                                     inManagedObjectContext:context];
        
        [listItem setValue:ingrediente.nome forKey:@"nome"];
        [listItem setValue:ingrediente.quantidade forKey:@"quantidade"];
        [listItem setValue:ingrediente.quantidadeDecimal forKey:@"quantidade_decimal"];
        [listItem setValue:ingrediente.unidade forKey:@"unidade"];
        [listItem setValue:self.receita.managedObject forKey:@"pertence_receita"];
        
        ObjectLista * objLista          = [ObjectLista new];
        objLista.nome                   = ingrediente.nome;
        objLista.quantidade             = ingrediente.quantidade;
        objLista.quantidade_decimal     = ingrediente.quantidadeDecimal;
        objLista.unidade                = ingrediente.unidade;
        objLista.managedObjectReceita   = self.receita.managedObject;
        
        // tenho de mudar os valores da quantidade do ingrediente antes de gravar
        
        if ([header.labelNumberServings.text floatValue] != [self.receita.servings floatValue]) {
            float calculado = ([ingrediente.quantidade floatValue] + [ingrediente.quantidadeDecimal floatValue])  * ([header.labelNumberServings.text floatValue] / [self.receita.servings floatValue] );
            [listItem setValue:[NSString stringWithFormat:@"%.2f",calculado] forKey:@"quantidade"];
            [listItem setValue:@"" forKey:@"quantidade_decimal"];
            
            objLista.quantidade         = [NSString stringWithFormat:@"%.2f",calculado];
            objLista.quantidade_decimal = @"";
            
        }
        [self.shopingCart addObject: objLista];
    }
    
}

-(void)callCart
{
    NSLog(@"abrir cart");
    // tenho de adicionar ou remover tudo do carrinho
    // mas quando removo tenho de arranjar forma de salvar as alteraçoes
    [self verificaMudarCartAllSelecte];
    
    if (self.cartAllSelected)
    {
        for (ObjectIngrediente * ing in self.items)
        {
            if ([ing class] != [NSNull class])
            ing.selecionado = NO;
        }
    }
    else
    {
        for (ObjectIngrediente * ing in self.items)
        {
            if ([ing class] != [NSNull class])
            ing.selecionado = YES;
        }
    }
    self.cartAllSelected = !self.cartAllSelected;
    [self.tabela reloadData];
    
    [self mostrarAlteracoesAddRemove:self.cartAllSelected];
}

-(void)verificaMudarCartAllSelecte
{
    
    BOOL muda = YES;
    for (ObjectIngrediente * ing in self.items)
    {
        if ([ing class] != [NSNull class])
        if (ing.selecionado != self.cartAllSelected)
        {
            muda = NO;
        }
    }
    
    if (!muda)
    {
        self.cartAllSelected = !self.cartAllSelected;
    }
}

-(void)mostrarAlteracoesAddRemove:(BOOL)added
{
     // tenho de mudar o texto da animaçao a informar que os ingredientes foram adicionados
     // e tambem tenho de mudar o texto do botao que diz add all
    
    NSString * textoParaBotao = @"";
    
    
    
    if (added)
    {
        header.labelAllitensAddedRemoved.text   = @"All itens added to shopping list";
        textoParaBotao                          = @"REMOVE FROM LIST";
    }
    else
    {
        header.labelAllitensAddedRemoved.text = @"All itens removed from shopping list";
        textoParaBotao                        = @"ADD TO LIST";
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        [header.addedRemovedView setAlpha:1];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:2 options:0 animations:^{
            header.labelAddRemoveAll.text = textoParaBotao;
            [header.addedRemovedView setAlpha:0];
        } completion:0];
    }];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        return 108;
    }
    
    
    if (indexPath.section == 1)
    {
        UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, largura   , 9999)];
        label.numberOfLines=0;
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        label.text = ((ObjectDirections *)[self.itemsDirections objectAtIndex:indexPath.row]).descricao;
    
        CGSize maximumLabelSize = CGSizeMake(320, 9999);
        CGSize expectedSize = [label sizeThatFits:maximumLabelSize];
        return expectedSize.height + 35 + 20;
    }
    else
    {
        return 44;
    }
    
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 )
    {
        return self.items.count;
    }
    else
    {
        return self.itemsDirections.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        IngredientesHeader * directios = [IngredientesHeader new];
        return directios.view;
    }
    else
    {
        DirectionsHeader * directios = [DirectionsHeader new];
        return directios.view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 108;
    }else
    {
        return 108;
    }
    
    return 60;
}
 */


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        
            //cell.textLabel.text = @"teste cell";
            
            [cell.contentView addSubview:ingHeadercell.view];
        
            return cell;
        }
        
        
        static NSString *simpleTableIdentifier = @"IngredienteCellTableViewCell";
   
    
        IngredienteCellTableViewCell *cell = (IngredienteCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IngredienteCellTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
        ObjectIngrediente * ing = [self.items objectAtIndex:indexPath.row];
    
        cell.LabelTitulo.text = [NSString stringWithFormat:@"%@%@%@ %@",ing.quantidade, ing.quantidadeDecimal ,ing.unidade , ing.nome];
        cell.ingrediente = ing;
        // tenho de calcular com base no que esta no header
    
        //cell.labelQtd.text = [self calcularValor:indexPath];
        cell.delegate = self;
    
        [cell addRemove: !ing.selecionado];
    
        return cell;
    }
    else if(indexPath.section == 1)
    {
        
        if (indexPath.row == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier2"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell.contentView addSubview:dirHeaderCell.view];
            
            return cell;
        }

        
        static NSString *simpleTableIdentifier = @"DirectionsCell";
        
        
        DirectionsCell *cell = (DirectionsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DirectionsCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        ObjectDirections * direct = [self.itemsDirections objectAtIndex:indexPath.row];
        
        cell.labelPasso.text        = [NSString stringWithFormat:@"%dº", indexPath.row + 1];
        cell.labelDescricao.text    = direct.descricao;
        if (direct.tempoMinutos == 0)
        {
            cell.labelTempo.text = @"Set timer";
        }else
        {
            cell.labelTempo.text        = [NSString stringWithFormat:@"%d min", direct.tempoMinutos];
        }
        return cell;
        
    }
    
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
    float Y = scrollView.contentOffset.y;

    if (Y >= 280 ) {
        [header.view setFrame:CGRectMake(0,  Y - 280 + 64 , self.view.frame.size.width, header.view.frame.size.height)];
    }
    else
    {
        [header.view setFrame:CGRectMake(0,  64 , self.view.frame.size.width, header.view.frame.size.height)];
    }
    
    
     
   // NSLog(@"Y = %f", Y);
}

-(NSString *)calcularValor:(NSIndexPath *)indexPath
{
    ObjectIngrediente * ing = [self.items objectAtIndex:indexPath.row];
    
    float calculado = ([ing.quantidade floatValue] + [ing.quantidadeDecimal floatValue])  * ([header.labelNumberServings.text floatValue] / [self.receita.servings floatValue] );
    //ing.quantidade = [NSString stringWithFormat:@"%.2f %@", calculado, ing.unidade];
    
    return [NSString stringWithFormat:@"%g %@", calculado, ing.unidade];
}


-(void)calendarioReceita
{
    NSLog(@"Delegado Calendario");
    Calendario * cal = [Calendario new];
    cal.receita = self.receita.managedObject;
    
    [self.navigationController pushViewController:cal animated:YES];
}

-(void)abrirNotes
{
    NotesViewer * notes = [NotesViewer new];
    // notes.delegate = self;
    notes.notas = self.receita.notas;
    notes.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:notes animated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
            notes.viewEscura.alpha = 0.6;
        }];}];
}

@end
