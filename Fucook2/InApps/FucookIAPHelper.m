//
//  FucookIAPHelper.m
//  Fucook
//
//  Created by Hugo Costa on 27/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "FucookIAPHelper.h"

@implementation FucookIAPHelper

+ (FucookIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static FucookIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"rcpk0",
                                      @"rcpk1",
                                      @"rcpk2",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
