//
//  Utils.h
//  Fucook2
//
//  Created by Hugo Costa on 03/03/15.
//  Copyright (c) 2015 Hugo Costa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectIngrediente.h"

@interface Utils : NSObject

+(NSString *)converter:(ObjectIngrediente *) ingrediente paraMetrica:(BOOL)imperial;
+ (NSString *)converterUnidade:(ObjectIngrediente *)ingrediente paraMetrica:(BOOL)imperial;

@end
