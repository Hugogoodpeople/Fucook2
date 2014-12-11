//
//  Directions.h
//  Fucook
//
//  Created by Rundlr on 10/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Directions : UIViewController
@property (nonatomic,assign) id delegate;
- (IBAction)btNewDirection:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tabela;

@property NSMutableArray * arrayOfItems;


@end
