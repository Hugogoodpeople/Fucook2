//
//  ObjectLivro.h
//  Fucook
//
//  Created by Hugo Costa on 14/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ObjectLivro : NSObject

@property NSString * titulo;
@property NSString * descricao;
@property NSString * id_inapps;
@property NSString * countReceitas;
@property UIImage  * imagem;
@property int        partilha;
@property NSManagedObject * managedImagem;
@property NSManagedObject * managedObject;
@property NSMutableArray  * receitas;

@property BOOL comprado;


@property BOOL breakFast;
@property BOOL dinner;
@property BOOL lunch;
@property BOOL dessert;

-(void)AddToCoreData:(NSManagedObjectContext *)context;

@end
