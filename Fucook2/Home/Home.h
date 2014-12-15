//
//  Home.h
//  Fucook
//
//  Created by Hugo Costa on 05/11/14.
//  Copyright (c) 2014 Hugo Costa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Home : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIToolbar *yoolbar;

@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)clickCarrinho:(id)sender;
- (IBAction)clickAgends:(id)sender;
- (IBAction)clickInApps:(id)sender;
- (IBAction)clickSettings:(id)sender;

@property (weak, nonatomic) IBOutlet UIToolbar *toobar;

@property NSMutableArray * items;
@property NSMutableArray * imagens;

@property (weak, nonatomic) IBOutlet UIView *viewVazia;
- (IBAction)clickAddBook:(id)sender;

@end
