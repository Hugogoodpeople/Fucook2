//
//  PesquisaReceitas.m
//  Fucook
//
//  Created by Hugo Costa on 14/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "PesquisaReceitas.h"
#import "PesquisaReceitaCell.h"
#import "AppDelegate.h"
#import "ObjectReceita.h"
#import "ReceitaVisualizar.h"



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
    
    UIButton * buttonback = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [buttonback addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [buttonback setImage:[UIImage imageNamed:@"btleft2"] forState:UIControlStateNormal];
    UIBarButtonItem *anotherButtonback = [[UIBarButtonItem alloc] initWithCustomView:buttonback];
    self.navigationItem.leftBarButtonItem = anotherButtonback;
    
}

- (IBAction)back:(id)sender {
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
        if( [receita.nome rangeOfString:searchText].location != NSNotFound )
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
    return 65;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pesquisaReceitas.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"PesquisaReceitaCell";
    
    PesquisaReceitaCell *cell = (PesquisaReceitaCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PesquisaReceitaCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.clipsToBounds = YES;
    }
    
    ObjectReceita * receita = [pesquisaReceitas objectAtIndex:indexPath.row];
    
    cell.labelTitulo.text = receita.nome;
    cell.labelDescricao.text = receita.livro.titulo;
    
    // NSString *key = [livro.imagem.description MD5Hash];
    // NSData *data = [FTWCache objectForKey:key];
    if ( [imagens objectAtIndex:indexPath.row]!= [NSNull null] )
    {
        cell.ImageThumbnail.image = [imagens objectAtIndex:indexPath.row];
    }
    else
    {
        //cell.imageCapa.image = [UIImage imageNamed:@"icn_default"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData * data = [receita.imagem valueForKey:@"imagem"];
            //[FTWCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            NSInteger index = indexPath.row;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.ImageThumbnail.image = image;
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
    //[self.navigationController pushViewController:[ReceitaController new] animated:YES];
    //[self.navigationController presentViewController:[ReceitaController new] animated:YES completion:^{}];
    
    
    
    ObjectReceita * objR = [pesquisaReceitas objectAtIndex:indexPath.row];
    ReceitaVisualizar * visualizar = [ReceitaVisualizar new];
    visualizar.receita = objR;
    
    [self.navigationController pushViewController:visualizar animated:YES];
}

@end
