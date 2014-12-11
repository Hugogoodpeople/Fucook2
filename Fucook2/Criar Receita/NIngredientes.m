//
//  NIngredientes.m
//  Fucook
//
//  Created by Rundlr on 11/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "NIngredientes.h"
#import "NewIngrediente.h"
#import "ObjectIngrediente.h"
#import "CellIngrediente.h"
#import "JAActionButton.h"


#define kFlagButtonColor        [UIColor colorWithRed:255.0/255.0 green:150.0/255.0 blue:0/255.0 alpha:1]
#define kMoreButtonColor        [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1]
#define kArchiveButtonColor     [UIColor colorWithRed:60.0/255.0 green:112.0/255.0 blue:168/255.0 alpha:1]
#define kUnreadButtonColor      [UIColor colorWithRed:0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1]

@interface NIngredientes ()

@end

@implementation NIngredientes

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tabela registerClass:[CellIngrediente class] forCellReuseIdentifier: @"CellIngrediente"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self editIngrediente:cell];
    }];
  
    
    return @[button1, button2];
}

- (IBAction)btnewIng:(id)sender {
    NSLog(@"Clicou add");
    if(self.delegate){
        [self.delegate performSelector:@selector(novoIng) withObject:nil];
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

/*
 - (CGFloat)tableView:(UITableView *)tableView
 heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 51;
 }
 */


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *str = @"Ingredient";
    NSString *str = ((ObjectIngrediente *)[self.arrayOfItems objectAtIndex:indexPath.row]).nome;
    CGSize size = [str sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:17] constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width -70, 999) lineBreakMode:NSLineBreakByWordWrapping];
    
    /*
     // esta parte até calcula +- mas nao fica perfeito
     
    CGSize size = [str sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont fontWithName:@"HelveticaNeue" size:17]}];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    size.height = ceilf(size.height);
    size.width = ceilf(size.width);
    
     */
    NSLog(@"%f",size.height);
    if(size.height == 0)
        return 51;
        
    return size.height +30;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CellIngrediente";
    ObjectIngrediente * ingrid = [self.arrayOfItems objectAtIndex:indexPath.row];
    
    CellIngrediente *cell = (CellIngrediente *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
  
    [cell addActionButtons:[self rightButtons] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationRight];
    

    cell.ingrediente = ingrid;
    cell.delegateHugo = self.delegate;
    cell.delegate = self;
    
    [cell addActionButtons:[self rightButtons] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationRight];
    
    cell.labelNome.text = [NSString stringWithFormat:@"%@%@%@ %@", ingrid.quantidade, ingrid.quantidadeDecimal , ingrid.unidade,ingrid.nome];;
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
        if (self.delegate)
        {
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

-(void)editIngrediente:(JASwipeCell *)cell
{
    NSIndexPath *indexPath = [self.tabela indexPathForCell:cell];
    ObjectIngrediente * ingre = [self.arrayOfItems objectAtIndex:indexPath.row];
    
    if (self.delegate) {
        [self.delegate performSelector:@selector(editarIngrediente:) withObject:ingre];
    }
}



@end
