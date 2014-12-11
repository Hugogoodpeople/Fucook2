//
//  Globals.m
//  Fucook
//
//  Created by Hugo Costa on 17/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "Globals.h"

@implementation Globals

static NSMutableArray *imagensTemp = nil;

+(void)setimagensTemp:(NSMutableArray *)array
{
    imagensTemp = array;
}

+(NSMutableArray *)getimagensTemp
{
    return imagensTemp;
}

+(void)addImageToTemp:(FXImageView *)imagem
{
    [imagensTemp addObject:imagensTemp];
}

+(FXImageView *)imagemAtIndex:(NSInteger )index
{
    if(imagensTemp.count < index-1 && imagensTemp.count > 0)
        return [imagensTemp objectAtIndex:index];
    
    return nil;
}

@end
