//
//  DragableMealPlaner.h
//  Fucook
//
//  Created by Hugo Costa on 13/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATSDragToReorderTableViewController.h"

@interface DragableMealPlaner : UITableViewController
{
    
}

@property NSMutableArray * arrayOfItems;
@property (nonatomic, assign) id delegate;

@property NSMutableArray * imagens;

-(void)actualizarImagens;

@end
