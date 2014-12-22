//
//  MealPlanerTableTableViewController.m
//  Fucook2
//
//  Created by Hugo Costa on 15/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "MealPlanerTable.h"
#import "MealPlanerCell.h"
#import "ObjectReceita.h"

@interface MealPlanerTable ()

@end

@implementation MealPlanerTable

@synthesize arrayOfItems,imagens;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Reordering";
    
    /*
     Populate array.
     */
    if (arrayOfItems == nil)
    {
        
        NSUInteger numberOfItems = 0;
        
        arrayOfItems = [[NSMutableArray alloc] initWithCapacity:numberOfItems];
        
    }
    
    [self actualizarImagens];
    
    
    
    NSLog(@"altura da tabela %f largura %f", self.tableView.frame.size.height , self.tableView.frame.size.width);
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView flashScrollIndicators];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*
     Disable reordering if there's one or zero items.
     For this example, of course, this will always be YES.
     */
    
#warning activar aqui se quiseres voltar atras para a dragable
    // [self setReorderingEnabled:( arrayOfItems.count > 1 )];
    
    return arrayOfItems.count;
}


/*
 // Override to support conditional editing of the table view.
 // This only needs to be implemented if you are going to be returning NO
 // for some items. By default, all items are editable.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return YES if you want the specified item to be editable.
 return YES;
 }
 
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 //add code here for when you hit delete
 }
 }
 */

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
#warning tenho de criar uma nova celula especialmente para esta parte... tem de ter 3 opções no total e nao 2 ou 4
    static NSString *simpleTableIdentifier = @"MealPlanerCell";
    
    MealPlanerCell *cell = (MealPlanerCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MealPlanerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ObjectReceita * rec = [self.arrayOfItems objectAtIndex:indexPath.row];
    
    cell.labelTitulo.text = rec.nome;
    cell.labelTempo.text = rec.tempo;
    cell.labelCategoria.text = rec.categoria;
    cell.labelDificuldade.text = rec.dificuldade;
    cell.labelCategoria.text = rec.categoriaAgendada;
    cell.receita = rec;
    // tenho de calcular com base no que esta no header
    
    //cell.labelQtd.text = [self calcularValor:indexPath];
    cell.delegate = self.delegate;
    
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

-(float)calcularAltura
{
    int alturaEcra = [UIScreen mainScreen].bounds.size.height;
    int devolver;
    
    if (alturaEcra == 480)
    {
        devolver = 295;
    }else if (alturaEcra == 568)
    {
        devolver = 370;
    }else if (alturaEcra == 667)
    {
        devolver = 450;
    }
    else if (alturaEcra == 736)
    {
        devolver = 510;
    }
    
    return devolver;
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

/*
 // should be identical to cell returned in -tableView:cellForRowAtIndexPath:
 - (UITableViewCell *)cellIdenticalToCellAtIndexPath:(NSIndexPath *)indexPath forDragTableViewController:(ATSDragToReorderTableViewController *)dragTableViewController {
 
 
 static NSString *simpleTableIdentifier = @"BookCell";
 
 MealPlanerCell *cell = (MealPlanerCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
 NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BookCell" owner:self options:nil];
 cell = [nib objectAtIndex:0];
 cell.transform = CGAffineTransformMakeRotation(M_PI/2);
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.contentView.clipsToBounds = YES;
 // [cell.contentView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
 
 // NSLog(@"altura da celula %f largura %f", cell.contentView.frame.size.height , cell.contentView.frame.size.width);
 
 
 
 cell.labelPagina.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
 
 
 [cell setSelected:YES];
 //cell.textLabel.text = [arrayOfItems objectAtIndex:indexPath.row];
 
 cell.delegate = self.delegate;
 
 return cell;
 
 
 }
 */

/*
	Required for drag tableview controller
 */

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    NSString *itemToMove = [arrayOfItems objectAtIndex:fromIndexPath.row];
    [arrayOfItems removeObjectAtIndex:fromIndexPath.row];
    [arrayOfItems insertObject:itemToMove atIndex:toIndexPath.row];
    
}

/*
 #pragma mark -
 #pragma mark Table view delegate
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
 }
 
 
 #pragma mark -
 #pragma mark Memory management
 
 - (void)didReceiveMemoryWarning {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Relinquish ownership any cached data, images, etc that aren't in use.
 }
 */


@end

