//
//  NIngredientes.h
//  Fucook
//
//  Created by Rundlr on 11/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NIngredientes : UIViewController <UITableViewDataSource, UITableViewDelegate>
- (IBAction)btnewIng:(id)sender;
@property (nonatomic,assign) id delegate;
@property (weak, nonatomic) IBOutlet UITableView *tabela;

@property NSMutableArray * arrayOfItems;

@end
