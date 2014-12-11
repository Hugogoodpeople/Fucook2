//
//  ObjectCalendario.h
//  Fucook
//
//  Created by Hugo Costa on 21/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface ObjectCalendario : NSObject

@property NSDate * data;
@property NSString * categoria;
@property NSMutableArray * receitas;

@property NSManagedObject * managedObject;

@property NSManagedObject * etapa;

@end
