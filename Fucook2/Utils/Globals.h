//
//  Globals.h
//  Fucook
//
//  Created by Hugo Costa on 17/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FXImageView.h"

@interface Globals : NSObject
+(void)setArrayInApps:(NSMutableArray *)inApps;
+(NSMutableArray *)getArrayInApps;
+(void)setImperial:(BOOL)verdade;
+(BOOL)getImperial;
+(void)setimagensTemp:(NSMutableArray *)array;
+(NSMutableArray *)getimagensTemp;
+(void)addImageToTemp:(FXImageView *)imagem;
+(FXImageView *)imagemAtIndex:(NSInteger )index;

@end
