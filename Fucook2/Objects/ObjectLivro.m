//
//  ObjectLivro.m
//  Fucook
//
//  Created by Hugo Costa on 14/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "ObjectLivro.h"

@implementation ObjectLivro


-(void)AddToCoreData:(NSManagedObjectContext *)context
{
    NSManagedObject *Livro = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Livros"
                              inManagedObjectContext:context];
    [Livro setValue:self.titulo forKey:@"titulo"];
    [Livro setValue:self.descricao forKey:@"descricao"];
    [Livro setValue:self.managedImagem forKey:@"contem_imagem"];
    [Livro setValue:[NSNumber numberWithBool:NO] forKey:@"comprado"];
    
    self.managedObject = Livro;
    
}


@end
