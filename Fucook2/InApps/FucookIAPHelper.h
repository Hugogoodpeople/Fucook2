//
//  FucookIAPHelper.h
//  Fucook
//
//  Created by Hugo Costa on 27/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAPHelper.h"

@interface FucookIAPHelper : IAPHelper

+ (FucookIAPHelper *)sharedInstance;

@end