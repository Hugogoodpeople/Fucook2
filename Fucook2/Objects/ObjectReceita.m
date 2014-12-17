//
//  ObjectReceita.m
//  Fucook
//
//  Created by Hugo Costa on 18/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "ObjectReceita.h"
#import "ObjectIngrediente.h"
#import "ObjectDirections.h"
#import "AppDelegate.h"

@implementation ObjectReceita


-(void)setTheManagedObject:(NSManagedObject *)managedObject
{
    // tenho de saber qual o livro a qual pertence esta receita
    self.livro = [ObjectLivro new];
    NSManagedObject * managedLivro = [managedObject valueForKey:@"pertence_livro"];
    
    self.livro.titulo    = [managedLivro valueForKey:@"titulo"];
    self.livro.descricao = [managedLivro valueForKey:@"descricao"];

    self.data_criado     = [managedObject valueForKey:@"data_criado"];
    self.nome            = [managedObject valueForKey:@"nome"];
    self.categoria       = [managedObject valueForKey:@"categoria"];
    self.servings        = [managedObject valueForKey:@"nr_pessoas"];
    self.dificuldade     = [managedObject valueForKey:@"dificuldade"];
    self.tempo           = [managedObject valueForKey:@"tempo"];
    self.managedImagem          = [managedObject valueForKey:@"contem_imagem"];
    self.notas           = [managedObject valueForKey:@"notas"];
    
    
    NSManagedObject * imagem = [managedObject valueForKey:@"contem_imagem"];
    self.managedImagem          = imagem;
    self.managedObject   = managedObject;
    
    self.arrayIngredientes = [NSMutableArray new];
    NSSet * inggredientes = [managedObject valueForKey:@"contem_ingredientes"];
    for (NSManagedObject * managedIng in inggredientes)
    {
        ObjectIngrediente * ing = [ObjectIngrediente new];
        [ing setTheManagedObject:managedIng];
        [self.arrayIngredientes addObject:ing];
    }
    
    NSMutableArray * arrayTemp = [NSMutableArray new];
    NSSet * etapas = [managedObject valueForKey:@"contem_etapas"];
    for (NSManagedObject * nanageDirections in etapas)
    {
        ObjectDirections * dir = [ObjectDirections new];
        [dir setTheManagedObject:nanageDirections];
        [arrayTemp addObject:dir];
    }
    
    NSArray *sortedArray;
    sortedArray = [arrayTemp sortedArrayUsingSelector:@selector(compare:)];
    
    self.arrayEtapas = [NSMutableArray new];
    [self.arrayEtapas addObjectsFromArray: sortedArray];
    
}

- (NSComparisonResult)compare:(ObjectReceita *)otherObject
{
    
    NSDate * primeiro = self.data_criado;
    NSDate * segundo  = otherObject.data_criado;
    
    return [primeiro compare:segundo];
}

-(void)AddToCoreData:(NSManagedObjectContext *)context
{
    NSManagedObject *Livro = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Receitas"
                              inManagedObjectContext:context];
    [Livro setValue:self.nome               forKey:@"nome"];
    [Livro setValue:self.data_criado        forKey:@"data_criado"];
    [Livro setValue:self.categoria          forKey:@"categoria"];
    [Livro setValue:self.servings           forKey:@"nr_pessoas"];
    [Livro setValue:self.dificuldade        forKey:@"dificuldade"];
    [Livro setValue:self.tempo              forKey:@"tempo"];
    [Livro setValue:self.managedImagem             forKey:@"contem_imagem"];
    [Livro setValue:self.notas              forKey:@"notas"];
    
    self.managedObject = Livro;
    
#warning ainda imcompleto
    
}




@end
