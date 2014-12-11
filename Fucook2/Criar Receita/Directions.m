//
//  Directions.m
//  Fucook
//
//  Created by Rundlr on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "Directions.h"
#import "ObjectDirections.h"
#import "CellEtapa.h"
#import "JAActionButton.h"

#define kFlagButtonColor        [UIColor colorWithRed:255.0/255.0 green:150.0/255.0 blue:0/255.0 alpha:1]
#define kMoreButtonColor        [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]
#define kArchiveButtonColor     [UIColor colorWithRed:60.0/255.0 green:112.0/255.0 blue:168/255.0 alpha:1]
#define kUnreadButtonColor      [UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1]

@interface Directions ()

@end

@implementation Directions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tabela registerClass:[CellEtapa class] forCellReuseIdentifier: @"CellEtapa"];
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

- (IBAction)btNewDirection:(id)sender {
    if(self.delegate){
        [self.delegate performSelector:@selector(novoDir) withObject:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfItems.count;
    //return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSArray *)rightButtons
{
    __typeof(self) __weak weakSelf = self;
    JAActionButton *button1 = [JAActionButton actionButtonWithTitle:@"Delete" color:kArchiveButtonColor handler:^(UIButton *actionButton, JASwipeCell*cell)
                               {
                                   [cell completePinToTopViewAnimation];
                                   [self rightMostButtonSwipeCompleted:cell];
                               }];
    
    JAActionButton *button2 = [JAActionButton actionButtonWithTitle:@"Edit" color:kFlagButtonColor handler:^(UIButton *actionButton, JASwipeCell*cell) {
        [self editEtapa:cell];
    }];
    
    
    return @[button1, button2];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *str = @"Ingredient";
    NSString *str = ((ObjectDirections *)[self.arrayOfItems objectAtIndex:indexPath.row]).descricao;
    CGSize size = [str sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:17] constrainedToSize:CGSizeMake(270, 999) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%f",size.height);
    if(size.height == 0)
        return 65;
    
    return size.height +54;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CellEtapa";
    
    
    ObjectDirections * ingrid = [self.arrayOfItems objectAtIndex:indexPath.row];
    
    
    /*
    
    CellEtapa *cell = (CellEtapa *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellEtapa" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.clipsToBounds = YES;
        //[cell.contentView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        // NSLog(@"altura da celula %f largura %f", cell.contentView.frame.size.height , cell.contentView.frame.size.width);
    }
    
    cell.ingrediente = ingrid;
    cell.delegate = self.delegate;
    
    cell.labelNome.text = [NSString stringWithFormat:@"%@", ingrid.descricao];
    cell.labelDesc.text = [NSString stringWithFormat:@"%d min", ingrid.tempoMinutos];
    
    return cell;
    
    
    */
    

    
    CellEtapa *cell = (CellEtapa *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    [cell addActionButtons:[self rightButtons] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationRight];
    
    
    cell.ingrediente = ingrid;
    cell.delegateHugo = self.delegate;
    cell.delegate = self;
    
    [cell addActionButtons:[self rightButtons] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationRight];
    
    //cell.labelNome.text = [NSString stringWithFormat:@"%@%@ %@ %@", ingrid.quantidade, ingrid.quantidadeDecimal , ingrid.unidade,ingrid.nome];;
    //cell.labelDesc.text = [NSString stringWithFormat:@"%@%@ %@", ingrid.quantidade, ingrid.quantidadeDecimal , ingrid.unidade];
    
    //[cell configureCellWithTitle:[NSString stringWithFormat:@"%@ %@ %@",ingrid.quantidade, ingrid.unidade, ingrid.nome]];
    [cell setNeedsLayout];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.arrayOfItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // tenho de mandar actualizar o controlador principar para recalcular o tamanho
        if (self.delegate) {
            [self.delegate performSelector:@selector(actualizarPosicoes) withObject:nil];
        }
    }
}

- (void)rightMostButtonSwipeCompleted:(JASwipeCell *)cell
{
    NSIndexPath *indexPath = [self.tabela indexPathForCell:cell];
    
    // ObjectIngrediente * objLista = [self.arrayOfItems objectAtIndex:indexPath.row];
    
    [self.arrayOfItems removeObjectAtIndex:indexPath.row];
    
    [self.tabela beginUpdates];
    [self.tabela deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tabela endUpdates];
    
    //[self deleteRow:objLista.managedObject];
    if (self.delegate) {
        [self.delegate performSelector:@selector(actualizarPosicoes) withObject:nil afterDelay:0.3];
    }
}

-(void)editEtapa:(JASwipeCell *)cell
{
    NSIndexPath *indexPath = [self.tabela indexPathForCell:cell];
    ObjectDirections * ingre = [self.arrayOfItems objectAtIndex:indexPath.row];
    
    if (self.delegate) {
        [self.delegate performSelector:@selector(editarEtapa:) withObject:ingre];
    }
}

@end
