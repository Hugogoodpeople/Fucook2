//
//  FucookIAPHelper.m
//  Fucook
//
//  Created by Hugo Costa on 27/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import "FucookIAPHelper.h"
#import "Globals.h"

@implementation FucookIAPHelper

+ (FucookIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static FucookIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        
        /* // era assim que estava antes... agora vou buscar valores vindos do servidor que depois graveis nas globais
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"rcpk0",
                                      @"rcpk1",
                                      @"rcpk2",
                                      nil];
        */
        NSMutableArray * array = [Globals getArrayInApps];
        
        
        NSSet * productIdentifiers =  [NSSet setWithArray:array];
        
        
        
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
