//
//  MealPlanerTableTableViewController.h
//  Fucook2
//
//  Created by Hugo Costa on 15/12/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealPlanerTable : UITableViewController

@property NSMutableArray * arrayOfItems;
@property (nonatomic, assign) id delegate;

@property NSMutableArray * imagens;

-(void)actualizarImagens;

@end