//
//  Utils.m
//  Fucook2
//
//  Created by Hugo Costa on 03/03/15.
//  Copyright (c) 2015 Hugo Costa. All rights reserved.
//

#import "Utils.h"


@implementation Utils

+ (NSString *)converter:(ObjectIngrediente *) ingrediente paraMetrica:(BOOL)imperial
{
    // ok aqui tenho de verificar o tipo de unidade usada para gravar
    // por isso vou criar uma lista de unidades que posso ter para as metricas
    
    // para métrico
    NSArray * metricoMin = @[@"Kg", @"g" ,@"L" ,@"ml"];
    NSArray * imperiaConv = @[@"0.453592f" , @"28.3495" , @"0.473176" , @"29.5735"];
    
    // para imperial
    NSArray * imperialMin = @[@"lbs", @"oz", @"pt", @"fl"];
    NSArray * metricConv = @[@"2.20462" , @"0.035274" , @"2.11338" , @"0.033814"];

    // agora que tenho as listas tenho de comparar se o ingrediente pertence a alguma
    if ([metricoMin containsObject:ingrediente.unidade] && !imperial)
    {
        // se entrar aqui é porque pertence as metricas
        NSString * conversao = [metricConv objectAtIndex:[metricoMin indexOfObject:ingrediente.unidade]];
        
        float unidAnt = [ingrediente.quantidade floatValue];
        float unidConv = [conversao floatValue];
        
        NSString * resultado = [NSString stringWithFormat:@"%.2f", unidAnt * unidConv];
        
        return resultado;
    }
    else if([imperialMin containsObject:ingrediente.unidade] && imperial)
    {
        // pertence a imperiais
        NSString * conversao = [imperiaConv objectAtIndex:[imperialMin indexOfObject:ingrediente.unidade]];
        
        float unidAnt = [ingrediente.quantidade floatValue];
        float unidConv = [conversao floatValue];
        
        NSString * resultado = [NSString stringWithFormat:@"%.2f", unidAnt * unidConv];
        
        return resultado;
    }
    else
    {
        return ingrediente.quantidade;
    }
    
    
    
    return ingrediente.quantidade;
}

+ (NSString *)converterUnidade:(ObjectIngrediente *)ingrediente paraMetrica:(BOOL)imperial
{
    // para métrico
    NSArray * metricoMin = @[@"Kg", @"g" ,@"L" ,@"ml"];
    
    // para imperial
    NSArray * imperialMin = @[@"lbs", @"oz", @"pt", @"fl"];
    
    if ([metricoMin containsObject:ingrediente.unidade] && !imperial)
    {
        // se entrar aqui é porque pertence as metricas
        NSString * conversao = [imperialMin objectAtIndex:[metricoMin indexOfObject:ingrediente.unidade]];
        
        
        return conversao;
    }
    else if([imperialMin containsObject:ingrediente.unidade] && imperial)
    {
        // pertence a imperiais
        NSString * conversao = [metricoMin objectAtIndex:[imperialMin indexOfObject:ingrediente.unidade]];
        
        
        return conversao;
    }
    else
    {
        return ingrediente.unidade;
    }

    
    
    return ingrediente.unidade;
}

@end
