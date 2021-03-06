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
#import "ShareFucook.h"
#import "UIImage+ImageEffects.h"
#import "AvisoComprar.h"
#import "Utils.h"
#import "Globals.h"

@interface ReceitaVisualizar ()
{
    HeaderIngrediente       * header;
    IngredientesHeader      * ingHeadercell;
    DirectionsHeader        * dirHeaderCell;
    NSManagedObjectContext  * context;
    float largura;
    
    BOOL todasNaList;
    
}

@property NSMutableArray * shopingCart;
@property BOOL cartAllSelected;


@end

@implementation ReceitaVisualizar



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    
    self.title = self.receita.nome;
    
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 10, 40)];
    [buttonback addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft1"] forState:UIControlStateNormal];
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    //self.navigationItem.leftBarButtonItem = anotherButtonback;

    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:15];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects: anotherButtonback, negativeSpacer,nil];

    
    
    largura = [[UIScreen mainScreen] bounds].size.width - 44;
    
    //[self.tabela setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    
    self.cartAllSelected = YES;
    
    context = [AppDelegate sharedAppDelegate].managedObjectContext;
    ingHeadercell = [IngredientesHeader new];
    ingHeadercell.delegate = self;
    ingHeadercell.isFromInApps = self.isFromInApps;
    ingHeadercell.passo = self.receita.servings;
    [ingHeadercell.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 108)];
    
    dirHeaderCell = [DirectionsHeader new];
    dirHeaderCell.isFromInApps = self.isFromInApps;
    [dirHeaderCell.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    
    
    
    
    if(self.isFromInApps)
    {
        // ok se vier das inApps nao preciso ir buscar nada
        // na verdade precisa de ir buscar ao objecto receito
        [self setUpIngredientesInApps];
        
        
    }
    else
    {
        // como vem do gravado no core data tenho de ler da bd
        [self initializeShoppingCart];
        [self setUpIngredientes];
        self.tabela.tableFooterView = nil;
    }
    
}

-(void)shareLivro
{
    ShareFucook * share = [ShareFucook new];
    //share.delegate = self;
    share.receita = self.receita;
    share.isInInApps = NO;
    share.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:share animated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
            share.viewEscura.alpha = 0.6;
        }];}];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpIngredientesInApps
{
    self.items = [NSMutableArray new];
    // preciso desta cena porque as primeiras celulas deviam ser headers
    [self.items addObject:[NSNull new]];
    header = [HeaderIngrediente new];
    header.dificuldade      = self.receita.dificuldade;
    header.tempo            = self.receita.tempo;
    header.nome             = self.receita.nome;
    header.servings         = self.receita.servings;
    header.categoria        = self.receita.categoria;
    header.imagem           = self.receita.imagem;
    header.partilha         = self.receita.livro.partilha;
    
    [header.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, header.view.frame.size.height)];
    [self.tabela addSubview:header.view];
    
    UIView * viewDesnecessaria = [[UIView alloc] init];
    [viewDesnecessaria setFrame:CGRectMake(0, 0, self.view.frame.size.width, header.view.frame.size.height +64)];
    self.tabela.tableHeaderView = viewDesnecessaria;
    
    [self.items addObjectsFromArray:self.receita.arrayIngredientes];

    [self setUpDirectionsInApps];
    
}

-(void)setUpIngredientes
{
    // apenas para textes
    self.items = [NSMutableArray new];
    
    //[self.items addObject:[NSNull new]];
    
    // tenho de verificar aqui se os ingredientes já estão na shopinglist
    NSSet * receitas = [self.receita.managedObject valueForKey:@"contem_ingredientes"];
    NSMutableArray * arrayTemp = [NSMutableArray new];
    
    todasNaList = YES;
    
    for (NSManagedObject *pedido in receitas)
    {
        ObjectIngrediente * ingred = [ObjectIngrediente new];
        
        // para mais tarde poder apagar
        ingred.managedObject        = pedido;
        ingred.nome                 = [pedido valueForKey:@"nome"];
        ingred.quantidade           = [pedido valueForKey:@"quantidade"];
        ingred.quantidadeDecimal    = [pedido valueForKey:@"quantidade_decimal"];
        ingred.unidade              = [pedido valueForKey:@"unidade"];
        ingred.ordem                = [[pedido valueForKey:@"ordem"] intValue];
        ingred.selecionado          = [self verificarShoppingList:ingred];
        
        if (ingred.selecionado)
        {
            todasNaList = NO;
        }
        
        [arrayTemp addObject:ingred];
    }
    
    // aqui se todos os ingredientes estiverem na shoping list tenho de mudar o testo para remove from list
    
    
    NSArray *sortedArray;
    sortedArray = [arrayTemp sortedArrayUsingSelector:@selector(compare:)];
    self.items = [NSMutableArray arrayWithArray:sortedArray];
    
    [self.items insertObject:[NSNull new] atIndex:0];
    
    header = [HeaderIngrediente new];
    header.delegate = self;
    
    // para alterar o botao de adicionar e remover
    [self mostrarAlteracoesAddRemove:!todasNaList];
    
    header.dificuldade      = self.receita.dificuldade;
    header.tempo            = self.receita.tempo;
    header.nome             = self.receita.nome;
    header.servings         = self.receita.servings;
    header.categoria        = self.receita.categoria;
    NSData * data           = [self.receita.managedImagem valueForKey:@"imagem"];
    
    if (data)
        header.imagem = [UIImage imageWithData:data];
    else
    {
        header.imagem = [UIImage imageNamed:@"imgsample.png"];
    }
    
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

-(void)setUpDirectionsInApps
{
    self.itemsDirections = [NSMutableArray new];
    [self.itemsDirections addObject:[NSNull new]];
    
    
    // tenho de trocar o que aqui está por cenas vidas de memoria e não de coredata
    NSMutableArray * receitas = self.receita.arrayEtapas;
    
    NSArray *sortedArray;
    sortedArray = [receitas sortedArrayUsingSelector:@selector(compare:)];
    
    [self.itemsDirections addObjectsFromArray: sortedArray];
    
    [self.tabela reloadData];
    
    if(self.isFromInApps)
    {
        AvisoComprar * aviso = [AvisoComprar new];
        
        
        
        
        [aviso.view setFrame:CGRectMake(0, 570, self.tabela.frame.size.width -20, 385)];
        
        [self.tabela addSubview:aviso.view];
        
        aviso.labelDescricao.text = @"At Fucook we are passionate about phenomenal food. Some of the brightest men and women of all countries and generations have devoted their time and powers to this theme. Like them, we also believe cooking is as art. We also believe that when you cook together and share good food with your friends and family good things happen.\n\nHere, you will find some incredible recipes and we want people like you to be inspired by them.\n\nOur recipes give you the inspiration you need to build on the traditions and discoveries of others, and to begin to break the rules to create your own recipes.\n\nWe are always searching for new recipes that will complement us and inspire you.\n\nClick the buy button above to access this recipe and more recipes from this book.";
        
        if (self.receita.livro.partilha == 1) {
            aviso.labelTitulo.text = @"SHARE REQUIRED";
            aviso.labelDescricao.text = @"At Fucook we are passionate about phenomenal food. Some of the brightest men and women of all countries and generations have devoted their time and powers to this theme. Like them, we also believe cooking is as art. We also believe that when you cook together and share good food with your friends and family good things happen.\n\nHere, you will find some incredible recipes and we want people like you to be inspired by them.\n\nOur recipes give you the inspiration you need to build on the traditions and discoveries of others, and to begin to break the rules to create your own recipes.\n\nWe are always searching for new recipes that will complement us and inspire you.\n\nClick the unlock button above to access this recipe and more recipes from this book.";
        }
        
    }
    
    [self.tabela addSubview:header.view];
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

    if(self.isFromInApps)
    {
    
        AvisoComprar * aviso = [AvisoComprar new];
        [aviso.view setFrame:CGRectMake(10, 580, self.tabela.frame.size.width- 20, 385)];
        
        [self.tabela addSubview:aviso.view];
        
        aviso.labelDescricao.text = @"At Fucook we are passionate about phenomenal food. Some of the brightest men and women of all countries and generations have devoted their time and powers to this theme. Like them, we also believe cooking is as art. We also believe that when you cook together and share good food with your friends and family good things happen.\n\nHere, you will find some incredible recipes and we want people like you to be inspired by them.\n\nOur recipes give you the inspiration you need to build on the traditions and discoveries of others, and to begin to break the rules to create your own recipes.\n\nWe are always searching for new recipes that will complement us and inspire you.\n\nClick the buy button above to access this recipe and more recipes from this book.";
        
        if (self.receita.livro.partilha == 1)
        {
            aviso.labelTitulo.text = @"SHARE REQUIRED";
            aviso.labelDescricao.text = @"At Fucook we are passionate about phenomenal food. Some of the brightest men and women of all countries and generations have devoted their time and powers to this theme. Like them, we also believe cooking is as art. We also believe that when you cook together and share good food with your friends and family good things happen.\n\nHere, you will find some incredible recipes and we want people like you to be inspired by them.\n\nOur recipes give you the inspiration you need to build on the traditions and discoveries of others, and to begin to break the rules to create your own recipes.\n\nWe are always searching for new recipes that will complement us and inspire you.\n\nClick the unlock button above to access this recipe and more recipes from this book.";
        }
    }
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
    // NSLog(@"remover %@", ingrediente.nome);
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
            
            // este remover objecto nao funciona por isso tive de fazer um iterador
            
            NSMutableArray * temp = [NSMutableArray arrayWithArray:self.shopingCart];
            
            for (ObjectLista * objL in temp)
            {
                if ([objL.nome isEqualToString:list.nome]
                    && [objL.unidade isEqualToString:list.unidade])
                {
                    [self.shopingCart removeObject:objL];
                }
            }
            
            [self.shopingCart removeObject: list];
            
        }
        
    }
    
    if (self.shopingCart.count == 0 )
    {
        header.labelAllitensAddedRemoved.text = @"All itens removed from shopping list";
        header.labelAddRemoveAll.text = @"ADD TO LIST";
        self.cartAllSelected = NO;
    }
    
    
}

-(void)saveIngrediente:(ObjectIngrediente *) ingrediente
{
    // tenhe de verificar se o ingrediente ja foi inserido antes de poder adicionar de novo
    // quando for salvar os ingredientes tenho de ter em conta a quantidade de servings que tem de mudar os valores na tabela
    // como é que vou mudar os valores na tabela?
    
    
    float qtdActual     = [ingrediente.quantidade floatValue];
    float servingsNovo  = [ingHeadercell.textServings.text floatValue];
    float servingsAnti  = [self.receita.servings floatValue];
    
    
    float calculado = (qtdActual * servingsNovo)/ servingsAnti ;
    
    
    BOOL  podeGravar = YES;
    if (self.shopingCart.count == 0)
    {
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
        [listItem setValue:[NSString stringWithFormat:@"%g", calculado] forKey:@"quantidade"];
        [listItem setValue:ingrediente.quantidadeDecimal forKey:@"quantidade_decimal"];
        [listItem setValue:ingrediente.unidade forKey:@"unidade"];
        [listItem setValue:self.receita.managedObject forKey:@"pertence_receita"];
        
        ObjectLista * objLista          = [ObjectLista new];
        objLista.nome                   = ingrediente.nome;
        objLista.quantidade             = [NSString stringWithFormat:@"%g", calculado];
        objLista.quantidade_decimal     = ingrediente.quantidadeDecimal;
        objLista.unidade                = ingrediente.unidade;
        objLista.managedObjectReceita   = self.receita.managedObject;
        
        // tenho de mudar os valores da quantidade do ingrediente antes de gravar
        
        
       
        objLista.quantidade             = [NSString stringWithFormat:@"%g", calculado];
        
        [self.shopingCart addObject: objLista];
       

    }
 
    header.labelAllitensAddedRemoved.text   = @"All itens added to shopping list";
    header.labelAddRemoveAll.text = @"REMOVE FROM LIST";
    self.cartAllSelected = NO;
    
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

- (CGFloat)alturaCell:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 1)
    {
        return 55;
    }
    
    
    else if (indexPath.row == 0)
    {
        
        // quando está fechado tem 108 e aberto tem 270 :)
        return 108;
    }
    
    
    if (indexPath.section == 1)
    {
        UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, largura   , 9999)];
        label.numberOfLines=0;
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        label.text = ((ObjectDirections *)[self.itemsDirections objectAtIndex:indexPath.row]).descricao;
        
        CGSize maximumLabelSize = CGSizeMake(largura, 9999);
        CGSize expectedSize = [label sizeThatFits:maximumLabelSize];
        return expectedSize.height + 35 + 20;
    }
    else
    {
        return 44;
    }
    
    return 44;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self alturaCell:indexPath];
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
            cell.contentView.clipsToBounds = YES;
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
        
        NSString * quantidade = [self calcularValor:indexPath];
        
        
        NSString *val =[NSString stringWithFormat:@"%@ %@",quantidade  , ing.nome];
        val = [val stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        
        val = [NSString stringWithFormat:@" %@", val];
    
        cell.LabelTitulo.text = val;
        cell.ingrediente = ing;
        // tenho de calcular com base no que esta no header
    
        //cell.labelQtd.text = [self calcularValor:indexPath];
        cell.delegate = self;
        cell.isFromInApps = self.isFromInApps;
    
        if (!self.isFromInApps)
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
        
        cell.nomeReceita = self.receita.nome;
        cell.labelPasso.text        = [NSString stringWithFormat:@"%dº", indexPath.row];
        cell.labelDescricao.text    = direct.descricao;
        if (direct.tempoMinutos == 0)
        {
            cell.labelTempo.text = @"Set timer";
        }else
        {
            cell.labelTempo.text        = [NSString stringWithFormat:@"%d min", direct.tempoMinutos];
        }
        
        cell.isFromInApps = self.isFromInApps;
        
        return cell;

    }
    
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
    float Y = scrollView.contentOffset.y;

    if (Y >= 270 ) {
        [header.view setFrame:CGRectMake(0,  Y - 270 + 64 , self.view.frame.size.width, header.view.frame.size.height)];
    }
    else
    {
        [header.view setFrame:CGRectMake(0,  64 , self.view.frame.size.width, header.view.frame.size.height)];
    }
     
    // NSLog(@"Y = %f", Y);
}

-(NSString *)calcularValor:(NSIndexPath *)indexPath
{
    NSString * servings = ingHeadercell.textServings.text;
    
    if ( servings.length == 0 )
    {
        return @"0";
    }
    
    ObjectIngrediente * ing = [self.items objectAtIndex:indexPath.row];
    
    NSString * testeConversao = [Utils converter:ing paraMetrica:[Globals getImperial]];
    
    float qtdActual     = [testeConversao floatValue];
    float servingsNovo  = [ingHeadercell.textServings.text floatValue];
    float servingsAnti  = [self.receita.servings floatValue];
    
    if (ing.quantidade.floatValue == 0)
    {
        return @"";
    }
    
    float calculado = (qtdActual * servingsNovo)/ servingsAnti;
    
    
    NSString * unidadeConvertida = [Utils converterUnidade:ing paraMetrica:[Globals getImperial]];
    
    
    return [NSString stringWithFormat:@"%g%@", calculado, unidadeConvertida];
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
    notes.delegate = self;
    // notes.delegate = self;
    notes.notas = self.receita.notas;
    notes.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:notes animated:YES completion:^{
        [UIView animateWithDuration:0.2 animations:^{
            notes.viewEscura.alpha = 0.6;
        }];}];
}

-(void)actualizarNota:(NSString *)nota
{
    self.receita.notas = nota;
    [self.receita.managedObject setValue:nota forKey:@"notas"];
    
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
        return;
    }

}

/* // aqui já não preciso desta parte
-(UIImage *)blurredSnapshot:(UIView *)view
{
    
    // Now apply the blur effect using Apple's UIImageEffect category
    //UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
     UIImage *blurredSnapshotImage = [[self imageWithView:view] applyBlurWithRadius:2 tintColor:[UIColor clearColor] saturationDeltaFactor:1 maskImage:nil];
    
    // Be nice and clean your mess up
    UIGraphicsEndImageContext();
    
    return blurredSnapshotImage;
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
 */


-(void)actualizarServings
{
    [self.tabela reloadData];
}

-(void)openCloseServings
{
    // tenho de abrir de outra maneira para ficar porreiro pá
    //[header clickservings];
    
    // vou mudar de estratégia, vou colocar o picker dentro da celula e aumentar o tamanho da celula
    
}


@end
