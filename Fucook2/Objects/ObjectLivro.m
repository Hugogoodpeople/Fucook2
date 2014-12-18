//
//  ObjectLivro.m
//  Fucook
//
//  Created by Hugo Costa on 14/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "ObjectLivro.h"
#import "ObjectReceita.h"

@implementation ObjectLivro


-(void)AddToCoreData:(NSManagedObjectContext *)context
{
    NSManagedObject *Livro = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Livros"
                              inManagedObjectContext:context];
    [Livro setValue:self.titulo forKey:@"titulo"];
    
    // esta imagem ainda nao foi colacada correctamente porque ainda nao criei o managed object da imagem a ser associada ao livro
    //[Livro setValue:self.descricao forKey:@"descricao"];
    NSManagedObject *Imagem = [NSEntityDescription
                               insertNewObjectForEntityForName:@"Imagens"
                               inManagedObjectContext:context];
    
    NSData *imageData = UIImageJPEGRepresentation(self.imagem, 1.0);
    [Imagem setValue:imageData forKey:@"imagem"];
    [Livro setValue:Imagem forKey:@"contem_imagem"];

    
    
    //[Livro setValue:self.managedImagem forKey:@"contem_imagem"];
    [Livro setValue:[NSNumber numberWithBool:YES] forKey:@"comprado"];
    
    // isto nao chega... tenho tambem de adicionar as receitas e dentro de cada receita tenho de acinar as direcções e os ingredientes
    
    // primeiro as receitas
    
    NSMutableArray * managedArrayReceitas = [NSMutableArray new];
    
    for (ObjectReceita * receita in self.receitas) {
        [receita AddToCoreData:context];
        [managedArrayReceitas addObject:receita.managedObject];
    }
    
    
    
    
    [Livro setValue:[NSSet setWithArray:[[NSArray alloc] initWithArray:managedArrayReceitas]]  forKey:@"contem_receitas"];

    
    self.managedObject = Livro;
    
}


@end
