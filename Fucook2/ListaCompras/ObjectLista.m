//
//  ObjectLista.m
//  Fucook
//
//  Created by Hugo Costa on 17/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "ObjectLista.h"

@implementation ObjectLista

-(void)setTheManagedObject:(NSManagedObject *)managedObject forRecipe:(ObjectReceita * ) receita
{
    self.managedObject = managedObject;
    
    self.nome =[managedObject valueForKey:@"nome"];
    self.quantidade =[managedObject valueForKey:@"quantidade"];
    self.quantidade_decimal =[managedObject valueForKey:@"quantidade_decimal"];
    self.unidade =[managedObject valueForKey:@"unidade"];
    self.managedObjectReceita = receita.managedObject;

}

-(NSManagedObject *)gettheManagedObject:(NSManagedObjectContext *)context
{
    NSManagedObject *mangIngrediente = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"ShoppingList"
                                        inManagedObjectContext:context];
    
    [mangIngrediente setValue:self.nome forKey:@"nome"];
    [mangIngrediente setValue:self.quantidade forKey:@"quantidade"];
    [mangIngrediente setValue:self.quantidade_decimal forKey:@"quantidade_decimal"];
    [mangIngrediente setValue:self.unidade forKey:@"unidade"];
    [mangIngrediente setValue:self.managedObjectReceita forKey:@"pertence_receita"];
    
    return mangIngrediente;
}


@end
