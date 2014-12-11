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
@property NSString * countReceitas;
@property NSManagedObject * imagem;
@property NSManagedObject * managedObject;

@property BOOL breakFast;
@property BOOL dinner;
@property BOOL lunch;
@property BOOL dessert;

@end
