//
//  ObjecteIngrediente.m
//  Fucook
//
//  Created by Hugo Costa on 11/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "ObjectIngrediente.h"


@implementation ObjectIngrediente

/*
@dynamic nome;
@dynamic idIng;
@dynamic idReceita;
@dynamic unidade;
@dynamic quantidade;
@dynamic nutricao;
@dynamic selecionado;
*/

-(NSManagedObject *)getManagedObject:(NSManagedObjectContext *)context
{
    NSManagedObject *mangIngrediente = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"Ingredientes"
                                        inManagedObjectContext:context];
    
    [mangIngrediente setValue:self.nome forKey:@"nome"];
    [mangIngrediente setValue:self.quantidade forKey:@"quantidade"];
    [mangIngrediente setValue:self.quantidadeDecimal forKey:@"quantidade_decimal"];
    [mangIngrediente setValue:self.unidade forKey:@"unidade"];
    
    return mangIngrediente;
    
}

-(NSManagedObject *)gettheManagedObjectToList:(NSManagedObjectContext *)context fromReceita:(ObjectReceita *) receita
{
    NSManagedObject *mangIngrediente = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"ShoppingList"
                                        inManagedObjectContext:context];
    
    [mangIngrediente setValue:self.nome forKey:@"nome"];
    [mangIngrediente setValue:self.quantidade forKey:@"quantidade"];
    [mangIngrediente setValue:self.quantidadeDecimal forKey:@"quantidade_decimal"];
    [mangIngrediente setValue:self.unidade forKey:@"unidade"];
    [mangIngrediente setValue:receita.managedObject forKey:@"pertence_receita"];
    
    return mangIngrediente;
    
}

// tenho de criar um para poder adicionar ao carrinho de compras

-(void)setTheManagedObject:(NSManagedObject *)managedObject
{
    self.managedObject          = managedObject;
    self.nome                   = [managedObject valueForKey:@"nome"];
    self.quantidade             = [managedObject valueForKey:@"quantidade"];
    self.quantidadeDecimal      = [managedObject valueForKey:@"quantidade_decimal"];
    self.unidade                = [managedObject valueForKey:@"unidade"];
}

@end
