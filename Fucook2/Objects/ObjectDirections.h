//
//  ObjectDirections.h
//  Fucook
//
//  Created by Hugo Costa on 12/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface ObjectDirections : NSObject

@property NSString * idDirection;
@property int passo;
@property NSString * descricao;
@property int tempoMinutos;
@property NSManagedObject * managedObject;


-(NSManagedObject *)getManagedObject:(NSManagedObjectContext *)context;

-(void)setTheManagedObject:(NSManagedObject *)managedObject;



@end
