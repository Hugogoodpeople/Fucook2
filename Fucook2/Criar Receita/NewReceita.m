//
//  NewReceita.m
//  Fucook
//
//  Created by Rundlr on 07/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "NewReceita.h"
#import "HeaderNewReceita.h"
#import "FooterNewReceita.h"
#import "NIngredientes.h"
#import "Directions.h"
#import "NewIngrediente.h"
#import "NewNotes.h"
#import "NewDirections.h"
#import "ObjectIngrediente.h"
#import "ObjectDirections.h"

#import "AppDelegate.h"

@interface NewReceita ()
{
    HeaderNewReceita * headerFinal;
    NIngredientes * ingre;
    Directions * dir;
    FooterNewReceita * footerFinal;
    
    BOOL auxIng;
    BOOL auxDir;
    BOOL auxNotes;
    
    
    NSMutableArray * arrayIngredientes;
    NSMutableArray * arraydireccoes;
    NSMutableArray * arrayNotas;
    
    BOOL jaFoiAbertoAntes;
    
    BOOL foiAlterado;
}

@end

@implementation NewReceita

- (void)viewDidLoad {
    [super viewDidLoad];

    // aqui tenho de verificar se tenho ou não já uma receita para listar
    
    if (self.receita)
    {
        [self setUpReceita];
    }
    else
    {
        [self setUp];
    }
    
    // nao deveria ser necessário ter de chamar isto mas assim ele funciona correctamente sem dar algum problema aparente
    double delayInSeconds = 0.00;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // code to be executed on main thread.If you want to run in another thread, create other queue
        [self actualizarPosicoes];
    });
    
    
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 10, 40)];
    [buttonback addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft1"] forState:UIControlStateNormal];
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;

}

- (IBAction)back:(id)sender {
    // tenho de perguntar ao utilizadro se quer gravar ou não quando as cenas foram alteradas
    if (foiAlterado)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"changes were made, you want to save changes ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 2;
        [alert show];
    }else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)setfoiAlterado
{
    foiAlterado = YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2) {
        if (buttonIndex == 1)
        {
            [self AdicionarReceita];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)addIngrediente:(ObjectIngrediente *)ingr
{
    // para ir para o fundo
    [self scrollTotopPosition:ingre.view];

    
    foiAlterado = YES;
    [arrayIngredientes addObject:ingr];
    [self actualizarPosicoes];
    
    }

-(void)AdicionarDirections:(ObjectDirections *) direct
{
    // para ir para o fundo
    [self scrollTotopPosition:dir.view];

    
    foiAlterado = YES;
    direct.passo = (int)arraydireccoes.count +1;
    [arraydireccoes addObject:direct];
    [self actualizarPosicoes];
    
    }

-(void)adicionarNota:(NSString *) nota
{
    // para ir para o fundo
    [self scrollTotopPosition:footerFinal.view];

    foiAlterado = YES;
    [arrayNotas removeAllObjects];
    
    if (nota.length > 0)
        [arrayNotas addObject:nota];
    
    [self actualizarPosicoes];
    
}

-(void)setUpReceita
{
    [self setUp];
    
    headerFinal.textName.text       = self.receita.nome;
    headerFinal.labelCat.text       = self.receita.categoria;
    headerFinal.labelServ.text      = self.receita.servings;
    headerFinal.labelDif.text       = self.receita.dificuldade;
    headerFinal.labelPre.text       = self.receita.tempo;
    headerFinal.img.image           = [UIImage imageWithData:[self.receita.managedImagem valueForKey:@"imagem"]];
    
    [headerFinal.viewPrimeiraVez setFrame:headerFinal.buttonFotoJaExiste.frame];

    
    [headerFinal temFoto];
    
    if (self.receita.notas.length != 0)
        arrayNotas = [[NSMutableArray alloc] initWithArray:@[self.receita.notas]];
    
    arrayIngredientes = self.receita.arrayIngredientes;
    arraydireccoes    = self.receita.arrayEtapas;
    
}

-(void)setUp
{
    /* bt search*/
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 60, 32)];
    [button addTarget:self action:@selector(AdicionarReceita) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"btnsave2"] forState:UIControlStateNormal];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    //self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-4];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,anotherButton,nil];

    
    headerFinal = [HeaderNewReceita alloc];
    //////[headerFinal.view setFrame:CGRectMake(0, 0, headerFinal.view.frame.size.width, headerFinal.view.frame.size.height )];
    //headerHeight = headerFinal.view.frame.size.height;
    headerFinal.delegate = self;
    [self.scrollNewReceita addSubview: headerFinal.view];
    
    ingre = [NIngredientes alloc];
    // antes de dar o tamanho tenho de dar os ingredientes para ele calcular correctamente o tamanho
    
    //////[ingre.view setFrame:CGRectMake(0,  headerFinal.view.frame.size.height , ingre.view.frame.size.width, ingre.view.frame.size.height )];
    //headerHeight = headerFinal.view.frame.size.height;
    ingre.delegate = self;
    [self.scrollNewReceita addSubview: ingre.view];
    
    dir = [Directions alloc];
    //////[dir.view setFrame:CGRectMake(0,  headerFinal.view.frame.size.height+ingre.view.frame.size.height , dir.view.frame.size.width, dir.view.frame.size.height )];
    //headerHeight = headerFinal.view.frame.size.height;
    dir.delegate = self;
    [self.scrollNewReceita addSubview: dir.view];
    
    footerFinal = [FooterNewReceita alloc];
    //////[footerFinal.view setFrame:CGRectMake(0,  headerFinal.view.frame.size.height+ingre.view.frame.size.height+dir.view.frame.size.height, footerFinal.view.frame.size.width, footerFinal.view.frame.size.height )];
    //headerHeight = headerFinal.view.frame.size.height;
    footerFinal.delegatef = self;
    [self.scrollNewReceita addSubview: footerFinal.view];
    
    //////[self.scrollNewReceita setContentSize:CGSizeMake(self.view.frame.size.width, headerFinal.view.frame.size.height+footerFinal.view.frame.size.height+dir.view.frame.size.height+ingre.view.frame.size.height)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"Your Recipe";
    
    // inicializar os arrays para poder adicionar os valores
    arrayIngredientes = [NSMutableArray new];
    arraydireccoes    = [NSMutableArray new];
    arrayNotas        = [NSMutableArray new];
    
}

-(void)scrollToPositionTop
{
     [self.scrollNewReceita scrollRectToVisible:CGRectMake(0, 550, self.view.frame.size.width, 100) animated:NO];
}

-(void)scrollTotopPosition:(UIView *)rect
{
    CGRect frame = rect.frame;
    //frame.origin.y = frame.origin.y - frame.size.height - 100;
    
    float local = frame.origin.y + frame.size.height -200 ;
    
    [self.scrollNewReceita scrollRectToVisible:CGRectMake(0, local, self.view.frame.size.width, 100) animated:NO];
}

-(void)scrollToPosition:(UIView *)rect
{
    //[rect setFrame:CGRectMake(rect.frame.origin.x, rect.frame.origin.y + 100, rect.frame.size.width, rect.frame.size.height)];
    
    [self.scrollNewReceita scrollRectToVisible:rect.frame animated:YES];
}

-(void)actualizarPosicoes
{
    
    [UIView setAnimationsEnabled:NO];
    
    
    ingre.arrayOfItems = arrayIngredientes;
    [ingre.tabela reloadData];
    [ingre.tabela reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    dir.arrayOfItems = arraydireccoes;
    [dir.tabela reloadData];
    [dir.tabela reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    footerFinal.arrayOfItems = arrayNotas;
    [footerFinal.tabela reloadData];
    
    [UIView setAnimationsEnabled:YES];
    
    CGFloat tempo =.5;
    if (!jaFoiAbertoAntes) {
        jaFoiAbertoAntes = YES;
        tempo= 0;
    }else
    {
        foiAlterado = YES;
    }
    
    [UIView animateWithDuration:tempo animations:^{
        [headerFinal.view setFrame:CGRectMake(0, 0, headerFinal.view.frame.size.width, headerFinal.view.frame.size.height )];
        [ingre.view setFrame:CGRectMake(0,  headerFinal.view.frame.size.height , ingre.view.frame.size.width, 88 + [self calcularTamanhoTabela:ingre.tabela].height )];
        [dir.view setFrame:CGRectMake(0,  headerFinal.view.frame.size.height+ingre.view.frame.size.height , dir.view.frame.size.width, 88 + [self calcularTamanhoTabela:dir.tabela].height  )];
        [footerFinal.view setFrame:CGRectMake(0,  headerFinal.view.frame.size.height+ingre.view.frame.size.height+dir.view.frame.size.height, footerFinal.view.frame.size.width, 88 + [self calcularTamanhoTabela:footerFinal.tabela].height  )];
        [self.scrollNewReceita setContentSize:CGSizeMake(self.view.frame.size.width, headerFinal.view.frame.size.height+footerFinal.view.frame.size.height+dir.view.frame.size.height+ingre.view.frame.size.height +50 )];
    }];
    
}

-(CGSize)calcularTamanhoTabela:(UITableView *)table
{
    [table layoutIfNeeded];
    
    CGSize tableViewSize=table.contentSize;
    
    return tableViewSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)AdicionarReceita
{
    NSString * categorias = headerFinal.labelCat.text;
    
    if ([categorias length] == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You must select at least one category for this recipe" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        [self AdicionarReceitaCompleta];
    }
}

-(void)AdicionarReceitaCompleta
{
    NSLog(@"adicionar receita");
    
    AppDelegate* appDelegate = [AppDelegate sharedAppDelegate];
    NSManagedObjectContext* context = appDelegate.managedObjectContext;

    NSManagedObject *Receita;
    if (self.receita)
    {
        Receita = self.receita.managedObject;
    }
    else
    {
        Receita = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Receitas"
                              inManagedObjectContext:context];
    }

    NSString * nomeReceita = headerFinal.textName.text;
    NSString * categoria   = headerFinal.labelCat.text;
    NSString * servings    = headerFinal.labelServ.text;
    NSString * dificulty   = headerFinal.labelDif.text;
    NSString * tempo       = headerFinal.labelPre.text;
    
    
    NSDate * data_actual   = [NSDate new];
    if (self.receita) {
         data_actual   = self.receita.data_criado;
    }
   
    
    /*
    // aqui agora deixou de ser apenas uma nota e passou a ser uma lista de notas
    NSManagedObject * nota = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Nota"
                              inManagedObjectContext:context];
    // percorrer um ciclo para todas as posições das notas
    NSMutableArray * arrayNotas = [NSMutableArray new];
    for (NSString * notaString in footerFinal.arrayOfItems) {
        
    }
    */
    
    
    
    if (footerFinal.arrayOfItems.count == 1) {
        NSString * notas       = [footerFinal.arrayOfItems objectAtIndex:0];
        [Receita setValue:notas         forKey:@"notas"];

    }
    else
    {
        [Receita setValue:@""         forKey:@"notas"];
    }
    
    [Receita setValue:data_actual   forKey:@"data_criado"];
    [Receita setValue:nomeReceita   forKey:@"nome"];
    [Receita setValue:categoria     forKey:@"categoria"];
    [Receita setValue:servings      forKey:@"nr_pessoas"];
    [Receita setValue:dificulty     forKey:@"dificuldade"];
    [Receita setValue:tempo         forKey:@"tempo"];
    
    NSManagedObject *Imagem = [NSEntityDescription
                               insertNewObjectForEntityForName:@"Imagens"
                               inManagedObjectContext:context];
    
    //[self.livro.managedObject setValue:Receita forKey:@"contem_receitas"];
    // tenho de adicionar um array com o novo elemento
    
    NSMutableArray * arrayReceitas = [NSMutableArray new];
    
    NSSet * receitasNoLivro = [self.livro.managedObject valueForKey:@"contem_receitas"];
    
    for (NSManagedObject * rec in receitasNoLivro)
    {
        [arrayReceitas addObject:rec];
    }
    
    NSData *imageData = UIImageJPEGRepresentation(headerFinal.img.image, 0.15);
    [Imagem setValue:imageData forKey:@"imagem"];
    [Receita setValue:Imagem forKey:@"contem_imagem"];
    
    [arrayReceitas addObject:Receita];
    
    // agrora tenho de criar os ingredientes para serem adicionados a receita
    // tem de ser criado um ciclo para os ingredientes
    NSMutableArray * arrayManagedIngredientes = [NSMutableArray new];
    for (ObjectIngrediente * objIng in arrayIngredientes)
    {
        NSManagedObject * ing =[objIng getManagedObject:context];
       
        [arrayManagedIngredientes addObject:ing];
    }

    // tenho de remover todos os ingredientes anterios que ja tinham sido guardados
    NSSet * managedIngs = [Receita valueForKey:@"contem_ingredientes"];
    for (NSManagedObject * objIng in managedIngs)
    {
        [context deleteObject:objIng];
    }
    NSSet * managedEtapas = [Receita valueForKey:@"contem_etapas"];
    for (NSManagedObject * objEtp in managedEtapas)
    {
        [context deleteObject:objEtp];
    }
    
    
    [Receita setValue:[NSSet setWithArray:[[NSArray alloc] initWithArray:arrayManagedIngredientes]] forKey:@"contem_ingredientes"];
    ////////////////////// fim ingredientes \\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    // agrora tenho de criar os ingredientes para serem adicionados a receita
    // tem de ser criado um ciclo para os ingredientes
    NSMutableArray * arrayManagedDirecoes = [NSMutableArray new];
    for (ObjectDirections * Objdirections in arraydireccoes)
    {
        [arrayManagedDirecoes addObject:[Objdirections getManagedObject:context]];
    }
    
    
    [Receita setValue:[NSSet setWithArray:[[NSArray alloc] initWithArray:arrayManagedDirecoes]] forKey:@"contem_etapas"];
    
    ////////////////////// fim direcções \\\\\\\\\\\\\\\\\\\\\\\\\\\

    
    // este tem de ser o ultimo passo a concluir
    [self.livro.managedObject setValue:[NSSet setWithArray:[[NSArray alloc] initWithArray:arrayReceitas]]  forKey:@"contem_receitas"];
    
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        return;
    }

    [self listarTodasReceitas:context];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)listarTodasReceitas:(NSManagedObjectContext *)context
{
    // para ir buscar os dados prestendidos a base de dados
        NSSet * receitas = [self.livro.managedObject valueForKey:@"contem_receitas"];
        for (NSManagedObject * receita in receitas)
        {
            NSLog(@"************************** Receita ***************************");
            NSLog(@"Nome receita: %@", [receita valueForKey:@"nome"]);
        }
}

-(void)novoIng
{
    NewIngrediente *obj = [NewIngrediente new];
    obj.delegate = self;
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)removerIngrediente:(NSObject *)ingrediente
{
    foiAlterado = YES;
    
    // tenho de verificar o tipo da classe
    if([ingrediente isKindOfClass:[ObjectIngrediente class]])
    {
        [arrayIngredientes removeObject:ingrediente];
    }
    
    if ([ingrediente isKindOfClass:[ObjectDirections class]]) {
        [arraydireccoes removeObject:ingrediente];
    }
    
    if ([ingrediente isKindOfClass:[NSString class]]) {
        [arrayNotas removeObject:ingrediente];
    }
    
    [self actualizarPosicoes];

}

-(void)novoNote
{
    NewNotes *obj = [NewNotes new];
    obj.delegate = self;
    // tenho de verificar se ja tinha notas antes para nao ter de escerver tudo de novo
    if (arrayNotas.count != 0)
        obj.textoNota = [arrayNotas objectAtIndex:0];
    
    [self.navigationController pushViewController:obj animated:YES];
}

-(void)novoDir
{
    NewDirections *obj = [NewDirections new];
    obj.delegate = self;
    [self.navigationController pushViewController:obj animated:YES];
}


#warning alterar aqui
-(void)animarIngre:(NSNumber *) num outro:(NSNumber *) num2
{
     NSLog(@"Num1 %d", auxIng);
    if(auxIng==0){
        [UIView animateWithDuration:0.5 animations:^{
            [ingre.view setFrame:CGRectMake(0, num.floatValue, ingre.view.frame.size.width, 101 + [self calcularTamanhoTabela:ingre.tabela].height )];
            [dir.view setFrame:CGRectMake(0, ingre.view.frame.origin.y+ingre.view.frame.size.height, ingre.view.frame.size.width, 101 + [self calcularTamanhoTabela:dir.tabela].height )];
            [footerFinal.view setFrame:CGRectMake(0, dir.view.frame.origin.y+dir.view.frame.size.height, ingre.view.frame.size.width, 101 + [self calcularTamanhoTabela:footerFinal.tabela].height )];
            [self.scrollNewReceita setContentSize:CGSizeMake(self.view.frame.size.width, headerFinal.view.frame.size.height+footerFinal.view.frame.size.height+dir.view.frame.size.height+ingre.view.frame.size.height+num2.floatValue +50 )];
        } completion:^(BOOL finished) {
            // nao preciso fazer nada aqui depois do completion block
        }];
        auxIng=1;
        NSLog(@"Num2 %d", auxIng);
        NSLog(@"tamanho o ingredi: %f", ingre.view.frame.size.height);
         NSLog(@"tamanho o dir: %f", dir.view.frame.size.height);
         //NSLog(@"tamanho o ingredi: %f", ingre.view.frame.origin.y+ingre.view.frame.size.height);
    }else if(auxIng==1){
        [UIView animateWithDuration:0.5 animations:^{
            [ingre.view setFrame:CGRectMake(0, num.floatValue, ingre.view.frame.size.width, 101 + [self calcularTamanhoTabela:ingre.tabela].height )];
            [dir.view setFrame:CGRectMake(0, ingre.view.frame.origin.y+ingre.view.frame.size.height, ingre.view.frame.size.width, 101 + [self calcularTamanhoTabela:dir.tabela].height )];
            [footerFinal.view setFrame:CGRectMake(0, dir.view.frame.origin.y+dir.view.frame.size.height, ingre.view.frame.size.width, 101 + [self calcularTamanhoTabela:footerFinal.tabela].height )];
            [self.scrollNewReceita setContentSize:CGSizeMake(self.view.frame.size.width, headerFinal.view.frame.size.height+footerFinal.view.frame.size.height+dir.view.frame.size.height+ingre.view.frame.size.height-num2.floatValue+10 +50 )];
        }completion:^(BOOL finished) {
            // nao preciso fazer nada aqui depois do completion block
        }];
        auxIng=0;
        NSLog(@"Num3 %d", auxIng);
        NSLog(@"tamanho o ingredi: %f", ingre.view.frame.origin.y+ingre.view.frame.size.height);
        NSLog(@"tamanho o dir: %f", dir.view.frame.origin.y+dir.view.frame.size.height);

    }
}

-(void)editarIngrediente:(ObjectIngrediente *)ingrediente
{
    NewIngrediente * controller = [NewIngrediente new];
    controller.delegate = self;
    controller.ingrediente = ingrediente;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)actualizarIngrediente:(ObjectIngrediente * )ingred :(ObjectIngrediente *) editedIngrediente
{
    foiAlterado = YES;
    [ingre.arrayOfItems replaceObjectAtIndex:[ingre.arrayOfItems indexOfObject:ingred] withObject:editedIngrediente];
    [self actualizarPosicoes];
}

-(void)editarEtapa:(ObjectDirections *)directions
{
    foiAlterado = YES;
    NewDirections * direct = [NewDirections new];
    direct.delegate = self;
    direct.directions = directions;
    
    [self.navigationController pushViewController:direct animated:YES];
}

-(void)actualizarEtapa:(ObjectDirections * )ingred :(ObjectDirections *) editedIngrediente
{
    [dir.arrayOfItems replaceObjectAtIndex:[dir.arrayOfItems indexOfObject:ingred] withObject:editedIngrediente];
    [self actualizarPosicoes];
}


@end
