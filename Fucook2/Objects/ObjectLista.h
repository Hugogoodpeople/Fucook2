//
//  ObjectLista.h
//  Fucook
//
//  Created by Hugo Costa on 17/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ObjectReceita.h"
#import "ObjectIngrediente.h"

@interface ObjectLista : NSObject

@property NSString * nome;
@property NSString * quantidade;
@property NSString * unidade;
@property NSString * quantidade_decimal;
@property NSManagedObject * managedObject;
@property NSManagedObject * managedObjectReceita;

-(void)setTheManagedObject:(NSManagedObject *)managedObject forRecipe:(ObjectReceita * ) receita;
-(NSManagedObject *)gettheManagedObject:(NSManagedObjectContext *)context;
-(ObjectIngrediente *)getObjectIngrediente;

@end
