//
//  FooterNewReceita.m
//  Fucook
//
//  Created by Rundlr on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "FooterNewReceita.h"
#import "CellIngrediente.h"

@interface FooterNewReceita ()
{
    float larguraEcra;
}

@end

@implementation FooterNewReceita

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    larguraEcra = [[UIScreen mainScreen] bounds].size.width;
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

- (IBAction)btNewNotes:(id)sender {
    if(self.delegatef){
        [self.delegatef performSelector:@selector(novoNote) withObject:nil];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfItems.count;
    //return 1;
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
    NSString *str = [self.arrayOfItems objectAtIndex:indexPath.row];
    CGSize size = [str sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:17] constrainedToSize:CGSizeMake(larguraEcra -50 , 999) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%f",size.height);
    if(size.height == 0)
        return 51;
    
    return size.height +30;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CellIngrediente";
    
    NSString * ingrid = [self.arrayOfItems objectAtIndex:indexPath.row];
    
    CellIngrediente *cell = (CellIngrediente *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellIngrediente" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.clipsToBounds = YES;
        //[cell.contentView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        // NSLog(@"altura da celula %f largura %f", cell.contentView.frame.size.height , cell.contentView.frame.size.width);
    }
    
    cell.delegate = self.delegatef;
    cell.ingrediente = ingrid;
    
    cell.labelNome.text = ingrid;
    //cell.labelDesc.text = @"";
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.arrayOfItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        // tenho de mandar actualizar o controlador principar para recalcular o tamanho
        if (self.delegatef) {
            [self.delegatef performSelector:@selector(actualizarPosicoes) withObject:nil];
        }
        
    }
}
@end
