//
//  ObjectReceita.h
//  Fucook
//
//  Created by Hugo Costa on 18/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ObjectLivro.h"

@interface ObjectReceita : NSObject

@property NSString * nome;
@property NSString * tempo;
@property NSString * dificuldade;
@property NSString * categoria;
@property NSString * servings;
@property NSString * notas;
@property NSDate   * data_criado;

// dava jeito ter isto aqui para saber o que marcou na agenda
@property NSString * categoriaAgendada;

@property NSMutableArray * arrayIngredientes;
@property NSMutableArray * arrayEtapas;

@property NSManagedObject * agendamento;

@property NSManagedObject * imagem;
@property NSManagedObject * managedObject;
@property ObjectLivro     * livro;

-(void)setTheManagedObject:(NSManagedObject *)managedObject;

@end
